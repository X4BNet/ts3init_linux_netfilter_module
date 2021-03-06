#ifndef _TS3INIT_SIPHASH_H
#define _TS3INIT_SIPHASH_H

/*
   SipHash reference C implementation
   Copyright (c) 2012-2014 Jean-Philippe Aumasson
   <jeanphilippe.aumasson@gmail.com>
   Copyright (c) 2012-2014 Daniel J. Bernstein <djb@cr.yp.to>
   Modified by TeamSpeak Systems for use in ts3init kernel module
   Copyright (c) 2016 Maximilian Muenchow <maximilian muenchow [at] teamspeak.com>
   Copyright (c) 2016 Niels Werensteijn <niels werensteijn [at] teamspeak.com>
   To the extent possible under law, the author(s) have dedicated all copyright
   and related and neighboring rights to this software to the public domain
   worldwide. This software is distributed without any warranty.
   You should have received a copy of the CC0 Public Domain Dedication along
   with
   this software. If not, see
   <http://creativecommons.org/publicdomain/zero/1.0/>.
*/
#ifndef __KERNEL__
#include <stdint.h>
#include <stdio.h>
#define u8 uint8_t
#define u32 uint32_t
#define u64 uint64_t
#define printk printf
#define le64_to_cpu(x) x
#define cpu_to_le64(x) x
#else
#include <linux/kernel.h>
#endif

struct ts3init_siphash_state
{
  u64 v0;
  u64 v1;
  u64 v2;
  u64 v3;
  u64 m;
  size_t len;
};

void ts3init_siphash_setup(struct ts3init_siphash_state* state, u64 k0, u64 k1);
void ts3init_siphash_update(struct ts3init_siphash_state* state, const u8 *in, size_t inlen);
u64 ts3init_siphash_finalize(struct ts3init_siphash_state* state);

#endif /*_TS3INIT_SIPHASH_H*/
