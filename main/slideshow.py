# Slideshow

import sys
import os
from datetime import datetime, timedelta
from random import random
from pathlib import Path
import shutil
import time

print('> ./main/slideshow.py')

src_dir = sys.argv[1] if len(sys.argv) > 1 else None
if src_dir is None or not os.path.isdir(sys.argv[2]):
    print('  invalid src dir; image selection paused')
    sys.exit(1)
active_dir = sys.argv[2] if len(sys.argv) > 2 else './photos/active'
active_photo_interval = int(sys.argv[3]) if len(sys.argv) > 3 else 5

valid_exts = ['.' + e for e in ['jpg', 'jpeg', 'png']]

photos = [[f.path for f in os.scandir(d.path) if f.is_file and os.path.splitext(f.path)[-1] in valid_exts] for d in os.scandir(src_dir) if d.is_dir()]
photos = [p for p in photos if len(p)]
total_members = len(photos)
total_photos = sum(len(p) for p in photos)

members = [
    {
        'prob': [
            i/total_members
            , (i + 1)/total_members
        ]
        , 'bias': 1 - (len(photos[i])/total_photos - (len(photos[i])/total_photos - 1/total_members)*((total_members - 1)/total_members)**total_members)
        , 'photos': [
            {
                'prob': [
                    k/len(photos[i])
                    , (k + 1)/len(photos[i])
                ]
                , 'path': photos[i][k]
            } for k in range(0, len(photos[i]))
        ]
    } for i in range(0, len(photos))
]

def get_image():
    mrand = random()
    midx = next(i for i,m in enumerate(members) if m['prob'][0] <= mrand < m['prob'][1])
    member = members[midx]

    if len(members) > 1:
        freed_prob = (member['prob'][1] - member['prob'][0]) * member['bias']
        total_standing_prob = sum(m['prob'][1] - m['prob'][0] for i,m in enumerate(members) if i != midx)
        for i,m in enumerate(members):
            standing_prob = m['prob'][1] - m['prob'][0]
            prob_stake = standing_prob/total_standing_prob
            m['prob'][0] = 0 if i == 0 else members[i - 1]['prob'][1]
            m['prob'][1] = 1 if i + 1 == len(members) else m['prob'][0] + standing_prob + (freed_prob * prob_stake if i != midx else -freed_prob)

    photos = member['photos']
    prand = random()
    pidx = next(i for i,p in enumerate(photos) if p['prob'][0] <= prand < p['prob'][1])
    photo = photos[pidx]

    if len(photos) > 1:
        total_freed_prob = photo['prob'][1] - photo['prob'][0]
        freed_prob = total_freed_prob/(len(photos) - 1)
        for i,p in enumerate(photos):
            standing_prob = p['prob'][1] - p['prob'][0]
            p['prob'][0] = 0 if i == 0 else photos[i - 1]['prob'][1]
            p['prob'][1] = 1 if i + 1 == len(photos) else p['prob'][0] + standing_prob + (freed_prob if i != pidx else -total_freed_prob)
    
    return photo['path']


active_photos_max = 1
active_photos = []
if os.path.isdir(active_dir):
    active_photos = [f.path for f in os.scandir(active_dir) if f.is_file]
else:
    Path(active_dir).mkdir(parents=True)

time_next = datetime.now()
while True:
    time_next = time_next + timedelta(seconds=active_photo_interval)
    active_photos.insert(0, get_image())
    print('  photo: ' + '/'.join(''.join(active_photos[0].split('.')[:-1]).split('/')[-2:]))
    shutil.copy(active_photos[0], active_dir)

    old_photos = [os.path.join(active_dir, p.split('/')[-1]) for p in active_photos[active_photos_max:]]
    for p in old_photos: os.remove(p)
    active_photos = active_photos[:active_photos_max]

    while datetime.now() < time_next:
        time.sleep(1)

