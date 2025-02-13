Return-Path: <live-patching+bounces-1176-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE78EA33A20
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 09:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 157A8188C88F
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 08:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EAD120C009;
	Thu, 13 Feb 2025 08:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGc8uELE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F256E207653;
	Thu, 13 Feb 2025 08:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739435884; cv=none; b=TgVxbdDJnaVvsPf+iyHC316tNoXKApUdnhgMFMfKGa3Adl5fo1z07EOvAJ/Om7+gu7sgopx24d+FWWGf7MIWvMuNSgDb/aGr+0nq8Q9htZHHcVEbBHTx5ySMGU//jzjkKaaoW/IFWvTuewX7ziqKi359w/2G3/2Pk0IF+M+XdBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739435884; c=relaxed/simple;
	bh=UdhDxAY3HZ5WBONxgVdy9EcRBl/ZZjTSOVhK3MO+aN4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FQQjEWKj/xI8ZpjjPkgZuESmgkHZFqwio79LxAQzUmPzu/OH6gIc4wApImLX9mBctWqo1I0ioXUgD/x6vKK+XZeDP8/t6T8uc733yJAJ74m8PZ/Ns89m8iHMBAyxp5seh9lFvr2tomnIGWt9qbeGkKU91dFYiuhMddtQGvcCKmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGc8uELE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01204C4CED1;
	Thu, 13 Feb 2025 08:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739435883;
	bh=UdhDxAY3HZ5WBONxgVdy9EcRBl/ZZjTSOVhK3MO+aN4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cGc8uELEPJRo89JwCNMhq05noHERYMv7C9/MU/aEM4l0VnLbR3XYPIDGOKNBg+7vH
	 fMM2y0BYEq66F3Wi3EvKCtse1/zVC34pqeGRCPiCFQ9W48XXhcLza49aMoDUFzR3N4
	 a4kQwGVYd1W/ToJuzEDfQCD2aGSMLadVNfVfD+rWhGFf5ZJqNvmBfc+bUm5RM8s7sV
	 j7sOyhIRHHKH35MxpmP6hd0EJ0HAJHXj9FCkBXzU++FYIsyBGAQlWK9nWx7W9MwwHe
	 FIwfSK0XzR6rxmMxgXbY0mS8hzRaz9Wr46IQYfTY0+KjmdGwCZDzpBzPI6eL5RO4mJ
	 FCQxYqLp4H6aQ==
From: Puranjay Mohan <puranjay@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>, Weinan Liu <wnliu@google.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Mark Rutland
 <mark.rutland@arm.com>, roman.gushchin@linux.dev, Will Deacon
 <will@kernel.org>, Ian Rogers <irogers@google.com>,
 linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
In-Reply-To: <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com>
 <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
 <mb61p1pw21f0v.fsf@kernel.org>
 <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
Date: Thu, 13 Feb 2025 08:37:57 +0000
Message-ID: <mb61pseoiz1cq.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Song Liu <song@kernel.org> writes:

> On Wed, Feb 12, 2025 at 11:26=E2=80=AFPM Puranjay Mohan <puranjay@kernel.=
org> wrote:
>>
>> Song Liu <song@kernel.org> writes:
>>
>> > On Wed, Feb 12, 2025 at 4:10=E2=80=AFPM Indu Bhagat <indu.bhagat@oracl=
e.com> wrote:
>> >>
>> >> On 2/12/25 3:32 PM, Song Liu wrote:
>> >> > I run some tests with this set and my RFC set [1]. Most of
>> >> > the test is done with kpatch-build. I tested both Puranjay's
>> >> > version [3] and my version [4].
>> >> >
>> >> > For gcc 14.2.1, I have seen the following issue with this
>> >> > test [2]. This happens with both upstream and 6.13.2.
>> >> > The livepatch loaded fine, but the system spilled out the
>> >> > following warning quickly.
>> >> >
>> >>
>> >> In presence of the issue
>> >> https://sourceware.org/bugzilla/show_bug.cgi?id=3D32666, I'd expect b=
ad
>> >> data in SFrame section.  Which may be causing this symptom?
>> >>
>> >> To be clear, the issue affects loaded kernel modules.  I cannot tell =
for
>> >> certain - is there module loading involved in your test ?
>> >
>> > The KLP is a module, I guess that is also affected?
>> >
>> > During kpatch-build, we added some logic to drop the .sframe section.
>> > I guess this is wrong, as we need the .sframe section when we apply
>> > the next KLP. However, I don't think the issue is caused by missing
>> > .sframe section.
>>
>> Hi, I did the same testing and did not get the Warning.
>>
>> I am testing on the 6.12.11 kernel with GCC 11.4.1.
>
> Could you please also try kernel 6.13.2?
>

I have tested with 6.13.2, here are the results:

[ec2-user@ip-172-31-32-86 ~]$ uname -r
6.13.2+

My tree looks like:

[ec2-user@ip-172-31-32-86 linux-upstream]$ git log --oneline
bdf4086dd (HEAD) arm64: Enable livepatch for ARM64
3904c7058 arm64: Define TIF_PATCH_PENDING for livepatch
b5de442a9 unwind: arm64: add reliable stacktrace support for arm64
fdc243fa8 unwind: arm64: Add sframe unwinder on arm64
87681b7c0 unwind: Implement generic sframe unwinder library
c8833ba50 unwind: add sframe v2 header
f3f3863cf arm64: entry: add unwind info for various kernel entries
57ab97f05 unwind: build kernel with sframe info
0da4b4b84 Linux 6.13.2

I have also fixed the 87681b7c0 ("unwind: Implement generic sframe
unwinder library")

with:

=2D-- >8 ---

diff --git a/kernel/sframe_lookup.c b/kernel/sframe_lookup.c
index 846f1da95d89..28bec5064dc7 100644
=2D-- a/kernel/sframe_lookup.c
+++ b/kernel/sframe_lookup.c
@@ -82,7 +82,7 @@ static struct sframe_fde *find_fde(const struct sframe_ta=
ble *tbl, unsigned long
        if (f >=3D tbl->sfhdr_p->num_fdes || f < 0)
                return NULL;
        fdep =3D tbl->fde_p + f;
=2D       if (ip < fdep->start_addr || ip >=3D fdep->start_addr + fdep->siz=
e)
+       if (ip < fdep->start_addr || ip > fdep->start_addr + fdep->size)
                return NULL;

        return fdep;
@@ -106,7 +106,7 @@ static int find_fre(const struct sframe_table *tbl, uns=
igned long pc,
        else
                ip_off =3D (int32_t)(pc - (unsigned long)tbl->sfhdr_p) - fd=
ep->start_addr;

=2D       if (ip_off < 0 || ip_off >=3D fdep->size)
+       if (ip_off < 0 || ip_off > fdep->size)
                return -EINVAL;

        /*

=2D-- 8< ---

GCC is gcc (GCC) 11.4.1 20230605 (Red Hat 11.4.1-2)

kpatch is from https://github.com/puranjaymohan/kpatch/tree/arm64_wip

I run the with following:

./kpatch/kpatch-build/kpatch-build --non-replace -d -v \
linux-upstream/vmlinux -s linux-upstream/ -c linux-upstream/.config \
kpatch/test/integration/linux-6.2.0/special-static.patch

and my dmesg output is:

[ec2-user@ip-172-31-32-86 ~]$ sudo dmesg
[  167.202596] livepatch_special_static: loading out-of-tree module taints =
kernel.
[  167.203217] livepatch_special_static: tainting kernel with TAINT_LIVEPAT=
CH
[  167.203760] livepatch_special_static: module verification failed: signat=
ure and/or required key missing - tainting kernel
[  167.205659] livepatch: enabling patch 'livepatch_special_static'
[  167.207358] livepatch: 'livepatch_special_static': starting patching tra=
nsition
[  168.264901] livepatch: 'livepatch_special_static': patching complete
[  410.641806] livepatch: 'livepatch_special_static': starting unpatching t=
ransition
[  412.389369] livepatch: 'livepatch_special_static': unpatching complete

I even ran stress-ng with the livepatch loaded to see if something
happens.


P.S. - The livepatch doesn't have copy_process() but only copy_signal(),
yours had copy_process() somehow.

Here is the symbol table of the .ko

Symbol table '.symtab' contains 169 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .note.gnu.build-=
id
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    2 .note.Linux
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT    3 .text
     4: 0000000000000000     0 SECTION LOCAL  DEFAULT    5 .exit.text
     5: 0000000000000000     0 SECTION LOCAL  DEFAULT    7 .init.text
     6: 0000000000000000     0 SECTION LOCAL  DEFAULT    9 .text.copy_signal
     7: 0000000000000000     0 SECTION LOCAL  DEFAULT   11 .text.kpatch_foo
     8: 0000000000000000     0 SECTION LOCAL  DEFAULT   13 .altinstructions
     9: 0000000000000000     0 SECTION LOCAL  DEFAULT   15 __patchable_func=
tion_entries
    10: 0000000000000000     0 SECTION LOCAL  DEFAULT   17 .codetag.alloc_t=
ags
    11: 0000000000000000     0 SECTION LOCAL  DEFAULT   18 .plt
    12: 0000000000000000     0 SECTION LOCAL  DEFAULT   19 .init.plt
    13: 0000000000000000     0 SECTION LOCAL  DEFAULT   20 .text.ftrace_tra=
mpoline
    14: 0000000000000000     0 SECTION LOCAL  DEFAULT   21 .rodata.str1.8
    15: 0000000000000000     0 SECTION LOCAL  DEFAULT   22 .modinfo
    16: 0000000000000000     0 SECTION LOCAL  DEFAULT   23 .sframe
    17: 0000000000000000     0 SECTION LOCAL  DEFAULT   25 .rodata.trace_ra=
w_output_task_newtask.str1.8
    18: 0000000000000000     0 SECTION LOCAL  DEFAULT   26 .rodata.trace_ra=
w_output_task_rename.str1.8
    19: 0000000000000000     0 SECTION LOCAL  DEFAULT   27 .rodata.sighand_=
ctor.str1.8
    20: 0000000000000000     0 SECTION LOCAL  DEFAULT   28 .rodata.str
    21: 0000000000000000     0 SECTION LOCAL  DEFAULT   29 .rodata.__mmdrop=
.str1.8
    22: 0000000000000000     0 SECTION LOCAL  DEFAULT   30 .rodata.copy_sig=
nal.str1.8
    23: 0000000000000000     0 SECTION LOCAL  DEFAULT   31 .rodata.mm_init.=
str1.8
    24: 0000000000000000     0 SECTION LOCAL  DEFAULT   32 .rodata.vm_area_=
alloc.str1.8
    25: 0000000000000000     0 SECTION LOCAL  DEFAULT   33 .rodata.dup_mmap=
.str1.8
    26: 0000000000000000     0 SECTION LOCAL  DEFAULT   34 .rodata.copy_pro=
cess.str1.8
    27: 0000000000000000     0 SECTION LOCAL  DEFAULT   35 .rodata.kernel_c=
lone.str1.8
    28: 0000000000000000     0 SECTION LOCAL  DEFAULT   36 .rodata.str__tas=
k__trace_system_name
    29: 0000000000000000     0 SECTION LOCAL  DEFAULT   37 .kpatch.strings
    30: 0000000000000000     0 SECTION LOCAL  DEFAULT   38 .kpatch.funcs
    31: 0000000000000000     0 SECTION LOCAL  DEFAULT   40 __versions
    32: 0000000000000000     0 SECTION LOCAL  DEFAULT   41 .bss
    33: 0000000000000000     0 SECTION LOCAL  DEFAULT   42 .bss.__key.4
    34: 0000000000000000     0 SECTION LOCAL  DEFAULT   43 .bss.__key.5
    35: 0000000000000000     0 SECTION LOCAL  DEFAULT   44 .bss.__key.6
    36: 0000000000000000     0 SECTION LOCAL  DEFAULT   45 .note.GNU-stack
    37: 0000000000000000     0 SECTION LOCAL  DEFAULT   46 .comment
    38: 0000000000000000     0 SECTION LOCAL  DEFAULT   47 .data
    39: 0000000000000000     0 SECTION LOCAL  DEFAULT   49 .exit.data
    40: 0000000000000000     0 SECTION LOCAL  DEFAULT   51 .init.data
    41: 0000000000000000     0 SECTION LOCAL  DEFAULT   53 .kpatch.callback=
s.pre_patch
    42: 0000000000000000     0 SECTION LOCAL  DEFAULT   54 .kpatch.callback=
s.post_patch
    43: 0000000000000000     0 SECTION LOCAL  DEFAULT   55 .kpatch.callback=
s.pre_unpatch
    44: 0000000000000000     0 SECTION LOCAL  DEFAULT   56 .kpatch.callback=
s.post_unpatch
    45: 0000000000000000     0 SECTION LOCAL  DEFAULT   57 .kpatch.force
    46: 0000000000000000     0 SECTION LOCAL  DEFAULT   58 .gnu.linkonce.th=
is_module
    47: 0000000000000000     0 SECTION LOCAL  DEFAULT   60 .debug_info
    48: 0000000000000000     0 SECTION LOCAL  DEFAULT   62 .debug_abbrev
    49: 0000000000000000     0 SECTION LOCAL  DEFAULT   63 .debug_loc
    50: 0000000000000000     0 SECTION LOCAL  DEFAULT   65 .debug_aranges
    51: 0000000000000000     0 SECTION LOCAL  DEFAULT   67 .debug_ranges
    52: 0000000000000000     0 SECTION LOCAL  DEFAULT   69 .debug_line
    53: 0000000000000000     0 SECTION LOCAL  DEFAULT   71 .debug_str
    54: 0000000000000000     0 SECTION LOCAL  DEFAULT   72 .debug_frame
    55: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS module-common.c
    56: 0000000000000062    52 OBJECT  LOCAL  DEFAULT   22 __UNIQUE_ID_verm=
agic547
    57: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT    2 $d
    58: 0000000000000000    24 OBJECT  LOCAL  DEFAULT    2 _note_19
    59: 0000000000000018    52 OBJECT  LOCAL  DEFAULT    2 _note_18
    60: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS patch-hook.c
    61: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT    3 $x
    62: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   15 $d
    63: 0000000000000008   104 FUNC    LOCAL  DEFAULT    3 patch_free_livep=
atch
    64: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT    5 $x
    65: 0000000000000000    36 FUNC    LOCAL  DEFAULT    5 patch_exit
    66: 0000000000000078   260 FUNC    LOCAL  DEFAULT    3 patch_free_scaff=
old
    67: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   21 $d
    68: 0000000000000188   280 FUNC    LOCAL  DEFAULT    3 patch_find_objec=
t_by_name
    69: 00000000000002a8   432 FUNC    LOCAL  DEFAULT    3 add_callbacks_to=
_patch_objects
    70: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT    7 $x
    71: 0000000000000008   584 FUNC    LOCAL  DEFAULT    7 patch_init
    72: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   47 $d
    73: 0000000000000000    16 OBJECT  LOCAL  DEFAULT   47 patch_objects
    74: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   41 $d
    75: 0000000000000000     8 OBJECT  LOCAL  DEFAULT   41 lpatch
    76: 0000000000000008     4 OBJECT  LOCAL  DEFAULT   41 patch_objects_nr
    77: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   49 $d
    78: 0000000000000000     8 OBJECT  LOCAL  DEFAULT   49 __UNIQUE_ID___ad=
dressable_cleanup_module737
    79: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   51 $d
    80: 0000000000000000     8 OBJECT  LOCAL  DEFAULT   51 __UNIQUE_ID___ad=
dressable_init_module736
    81: 0000000000000000    12 OBJECT  LOCAL  DEFAULT   22 __UNIQUE_ID_live=
patch739
    82: 000000000000000c    12 OBJECT  LOCAL  DEFAULT   22 __UNIQUE_ID_lice=
nse738
    83: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS fork.c
    84: 0000000000000008   496 FUNC    LOCAL  DEFAULT    9 copy_signal
    85: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   25 $d
    86: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   26 $d
    87: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   27 $d
    88: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   29 $d
    89: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   30 $d
    90: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   31 $d
    91: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   32 $d
    92: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   33 $d
    93: 0000000000000128     0 NOTYPE  LOCAL  DEFAULT   21 $d
    94: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   34 $d
    95: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   35 $d
    96: 0000000000000000     0 OBJECT  LOCAL  DEFAULT   42 __key.4
    97: 0000000000000000     0 OBJECT  LOCAL  DEFAULT   43 __key.5
    98: 0000000000000000     0 OBJECT  LOCAL  DEFAULT   44 __key.6
    99: 0000000000000000     5 OBJECT  LOCAL  DEFAULT   36 str__task__trace=
_system_name
   100: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   36 $d
   101: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B1
   102: 000000000000000e     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B2
   103: 000000000000001c     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B3
   104: 000000000000002a     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B4
   105: 0000000000000038     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B5
   106: 0000000000000046     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B6
   107: 0000000000000054     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B7
   108: 0000000000000062     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B8
   109: 0000000000000070     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B9
   110: 000000000000007e     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B10
   111: 000000000000008c     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B11
   112: 00000000000000a9     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B12
   113: 00000000000000c1     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B13
   114: 00000000000000d9     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B14
   115: 00000000000000f1     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B15
   116: 0000000000000109     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B16
   117: 0000000000000124     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B17
   118: 0000000000000132     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B18
   119: 000000000000014d     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B19
   120: 0000000000000168     0 NOTYPE  LOCAL  DEFAULT   28 .L14472^B20
   121: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS livepatch-specia=
l-static.mod.c
   122: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   58 $d
   123: 0000000000000018    35 OBJECT  LOCAL  DEFAULT   22 __UNIQUE_ID_srcv=
ersion549
   124: 000000000000003b     9 OBJECT  LOCAL  DEFAULT   22 __UNIQUE_ID_depe=
nds548
   125: 0000000000000044    30 OBJECT  LOCAL  DEFAULT   22 __UNIQUE_ID_name=
547
   126: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   40 $d
   127: 0000000000000000     0 OBJECT  LOCAL  DEFAULT OS [0xff20] .klp.sym.=
vmlinux.signal_cachep,1
   128: 0000000000000000  1216 OBJECT  LOCAL  DEFAULT   40 ____versions
   129: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   55 __kpatch_callbac=
ks_pre_unpatch_end
   130: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND __init_rwsem
   131: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND __list_add_valid=
_or_report
   132: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND __kmalloc_noprof
   133: 0000000000000000  1344 OBJECT  GLOBAL DEFAULT   58 __this_module
   134: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   54 __kpatch_callbac=
ks_post_patch
   135: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   57 __kpatch_force_f=
uncs
   136: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   17 __stop_alloc_tags
   137: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND hrtimer_init
   138: 0000000000000000    36 FUNC    GLOBAL DEFAULT    5 cleanup_module
   139: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND memcpy
   140: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND klp_enable_patch
   141: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND kfree
   142: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   53 __kpatch_callbac=
ks_pre_patch
   143: 0000000000000008   584 FUNC    GLOBAL DEFAULT    7 init_module
   144: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   55 __kpatch_callbac=
ks_pre_unpatch
   145: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   17 __start_alloc_ta=
gs
   146: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   38 __kpatch_funcs
   147: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND _printk
   148: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   57 __kpatch_force_f=
uncs_end
   149: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND queued_spin_lock=
_slowpath
   150: 0000000000000038     0 NOTYPE  GLOBAL DEFAULT   38 __kpatch_funcs_e=
nd
   151: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   54 __kpatch_callbac=
ks_post_patch_end
   152: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   53 __kpatch_callbac=
ks_pre_patch_end
   153: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND __list_del_entry=
_valid_or_report
   154: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND __mutex_init
   155: 0000000000000008    60 FUNC    GLOBAL DEFAULT   11 kpatch_foo
   156: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   56 __kpatch_callbac=
ks_post_unpatch_end
   157: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND kmem_cache_alloc=
_noprof
   158: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND __init_waitqueue=
_head
   159: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND strcmp
   160: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND jiffies
   161: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   56 __kpatch_callbac=
ks_post_unpatch
   162: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND __kmalloc_cache_=
noprof
   163: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND alt_cb_patch_nops
   164: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND kmalloc_caches
   165: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT OS [0xff20] .klp.sym.=
vmlinux.it_real_fn,0
   166: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT OS [0xff20] .klp.sym.=
vmlinux.posix_cputimers_group_init,0
   167: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT OS [0xff20] .klp.sym.=
vmlinux.tty_audit_fork,0
   168: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT OS [0xff20] .klp.sym.=
vmlinux.sched_autogroup_fork,0

and Sections:

[ec2-user@ip-172-31-32-86 ~]$ readelf -WS livepatch-special-static.ko
There are 78 section headers, starting at offset 0x1727d8:

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES =
Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00 =
     0   0  0
  [ 1] .note.gnu.build-id NOTE            0000000000000000 000040 000024 00=
   A  0   0  4
  [ 2] .note.Linux       NOTE            0000000000000000 000064 00004c 00 =
  A  0   0  4
  [ 3] .text             PROGBITS        0000000000000000 0000c0 000458 00 =
 AX  0   0 32
  [ 4] .rela.text        RELA            0000000000000000 000518 000570 18 =
  I 74   3  8
  [ 5] .exit.text        PROGBITS        0000000000000000 000a88 000024 00 =
 AX  0   0  8
  [ 6] .rela.exit.text   RELA            0000000000000000 000ab0 000048 18 =
  I 74   5  8
  [ 7] .init.text        PROGBITS        0000000000000000 000b00 000250 00 =
 AX  0   0 32
  [ 8] .rela.init.text   RELA            0000000000000000 000d50 000348 18 =
  I 74   7  8
  [ 9] .text.copy_signal PROGBITS        0000000000000000 001098 0001f8 00 =
 AX  0   0  8
  [10] .rela.text.copy_signal RELA            0000000000000000 001290 00024=
0 18   I 74   9  8
  [11] .text.kpatch_foo  PROGBITS        0000000000000000 0014d0 000044 00 =
 AX  0   0  8
  [12] .rela.text.kpatch_foo RELA            0000000000000000 001518 000078=
 18   I 74  11  8
  [13] .altinstructions  PROGBITS        0000000000000000 001590 00000c 00 =
  A  0   0  8
  [14] .rela.altinstructions RELA            0000000000000000 0015a0 000030=
 18   I 74  13  8
  [15] __patchable_function_entries PROGBITS        0000000000000010 0015d0=
 000038 00 WAL  3   0  8
  [16] .rela__patchable_function_entries RELA            0000000000000000 0=
01608 0000a8 18   I 74  15  8
  [17] .codetag.alloc_tags PROGBITS        0000000000000540 0016b0 000000 0=
0   W  0   0  1
  [18] .plt              PROGBITS        0000000000000000 0016b0 000001 00 =
 AX  0   0  1
  [19] .init.plt         PROGBITS        0000000000000000 0016b1 000001 00 =
  A  0   0  1
  [20] .text.ftrace_trampoline PROGBITS        0000000000000000 0016b2 0000=
01 00  AX  0   0  1
  [21] .rodata.str1.8    PROGBITS        0000000000000000 0016b8 000455 01 =
AMS  0   0  8
  [22] .modinfo          PROGBITS        0000000000000000 001b0d 000096 00 =
  A  0   0  1
  [23] .sframe           PROGBITS        0000000000000000 001ba8 0001ad 00 =
  A  0   0  8
  [24] .rela.sframe      RELA            0000000000000000 001d58 0000c0 18 =
  I 74  23  8
  [25] .rodata.trace_raw_output_task_newtask.str1.8 PROGBITS        0000000=
000000000 001e18 000032 01 AMS  0   0  8
  [26] .rodata.trace_raw_output_task_rename.str1.8 PROGBITS        00000000=
00000000 001e50 000030 01 AMS  0   0  8
  [27] .rodata.sighand_ctor.str1.8 PROGBITS        0000000000000000 001e80 =
000017 01 AMS  0   0  8
  [28] .rodata.str       PROGBITS        0000000000000000 001e97 000180 01 =
AMS  0   0  1
  [29] .rodata.__mmdrop.str1.8 PROGBITS        0000000000000000 002018 0000=
6b 01 AMS  0   0  8
  [30] .rodata.copy_signal.str1.8 PROGBITS        0000000000000000 002088 0=
0005f 01 AMS  0   0  8
  [31] .rodata.mm_init.str1.8 PROGBITS        0000000000000000 0020e8 00000=
f 01 AMS  0   0  8
  [32] .rodata.vm_area_alloc.str1.8 PROGBITS        0000000000000000 0020f8=
 000014 01 AMS  0   0  8
  [33] .rodata.dup_mmap.str1.8 PROGBITS        0000000000000000 002110 0000=
54 01 AMS  0   0  8
  [34] .rodata.copy_process.str1.8 PROGBITS        0000000000000000 002168 =
000017 01 AMS  0   0  8
  [35] .rodata.kernel_clone.str1.8 PROGBITS        0000000000000000 002180 =
000009 01 AMS  0   0  8
  [36] .rodata.str__task__trace_system_name PROGBITS        000000000000000=
0 002190 000005 00   A  0   0  8
  [37] .kpatch.strings   PROGBITS        0000000000000000 002195 00006c 00 =
  A  0   0  1
  [38] .kpatch.funcs     PROGBITS        0000000000000000 002208 000038 00 =
  A  0   0  8
  [39] .rela.kpatch.funcs RELA            0000000000000000 002240 000048 18=
   I 74  38  8
  [40] __versions        PROGBITS        0000000000000000 002288 0004c0 00 =
  A  0   0  8
  [41] .bss              NOBITS          0000000000000000 002748 00000c 00 =
 WA  0   0  8
  [42] .bss.__key.4      NOBITS          0000000000000000 002748 000000 00 =
 WA  0   0  8
  [43] .bss.__key.5      NOBITS          0000000000000000 002748 000000 00 =
 WA  0   0  8
  [44] .bss.__key.6      NOBITS          0000000000000000 002748 000000 00 =
 WA  0   0  8
  [45] .note.GNU-stack   PROGBITS        0000000000000000 002748 000000 00 =
     0   0  1
  [46] .comment          PROGBITS        0000000000000000 002748 00008d 01 =
 MS  0   0  1
  [47] .data             PROGBITS        0000000000000048 0027d8 000010 00 =
 WA  0   0  8
  [48] .rela.data        RELA            0000000000000000 0027e8 000030 18 =
  I 74  47  8
  [49] .exit.data        PROGBITS        0000000000000000 002818 000008 00 =
 WA  0   0  8
  [50] .rela.exit.data   RELA            0000000000000000 002820 000018 18 =
  I 74  49  8
  [51] .init.data        PROGBITS        0000000000000000 002838 000008 00 =
 WA  0   0  8
  [52] .rela.init.data   RELA            0000000000000000 002840 000018 18 =
  I 74  51  8
  [53] .kpatch.callbacks.pre_patch PROGBITS        0000000000000000 002858 =
000008 00  WA  0   0  1
  [54] .kpatch.callbacks.post_patch PROGBITS        0000000000000000 002860=
 000008 00  WA  0   0  1
  [55] .kpatch.callbacks.pre_unpatch PROGBITS        0000000000000000 00286=
8 000008 00  WA  0   0  1
  [56] .kpatch.callbacks.post_unpatch PROGBITS        0000000000000000 0028=
70 000008 00  WA  0   0  1
  [57] .kpatch.force     PROGBITS        0000000000000000 002878 000008 00 =
 WA  0   0  1
  [58] .gnu.linkonce.this_module PROGBITS        0000000000000000 002880 00=
0540 00  WA  0   0 64
  [59] .rela.gnu.linkonce.this_module RELA            0000000000000000 002d=
c0 000030 18   I 74  58  8
  [60] .debug_info       PROGBITS        0000000000000000 002df0 06041d 00 =
     0   0  1
  [61] .rela.debug_info  RELA            0000000000000000 063210 08a390 18 =
  I 74  60  8
  [62] .debug_abbrev     PROGBITS        0000000000000000 0ed5a0 002392 00 =
     0   0  1
  [63] .debug_loc        PROGBITS        0000000000000000 0ef932 031dd6 00 =
     0   0  1
  [64] .rela.debug_loc   RELA            0000000000000000 121708 004e30 18 =
  I 74  63  8
  [65] .debug_aranges    PROGBITS        0000000000000000 126538 000740 00 =
     0   0  1
  [66] .rela.debug_aranges RELA            0000000000000000 126c78 0000d8 1=
8   I 74  65  8
  [67] .debug_ranges     PROGBITS        0000000000000000 126d50 00a870 00 =
     0   0  1
  [68] .rela.debug_ranges RELA            0000000000000000 1315c0 001320 18=
   I 74  67  8
  [69] .debug_line       PROGBITS        0000000000000000 1328e0 010623 00 =
     0   0  1
  [70] .rela.debug_line  RELA            0000000000000000 142f08 000078 18 =
  I 74  69  8
  [71] .debug_str        PROGBITS        0000000000000000 142f80 02b764 01 =
 MS  0   0  1
  [72] .debug_frame      PROGBITS        0000000000000000 16e6e8 001900 00 =
     0   0  8
  [73] .rela.debug_frame RELA            0000000000000000 16ffe8 000b28 18 =
  I 74  72  8
  [74] .symtab           SYMTAB          0000000000000000 170b10 000fd8 18 =
    75 129  8
  [75] .strtab           STRTAB          0000000000000000 171ae8 0006cc 00 =
     0   0  1
  [76] .shstrtab         STRTAB          0000000000000000 1721b4 000576 00 =
     0   0  1
  [77] .klp.rela.vmlinux..text.copy_signal RELA 0000000000000000 172730 000=
0a8 18 AIo 74   9  8
=20=20

Thanks,
Puranjay

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZ62vZxQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2nYWFAQDCL8PDCml4K/SLlDU5S1/a0vM64D4G
sVBWqSpXd25wYAEA842PkMBdgwG7LTp4gFN7ZTkuJGTW36pSrUs7J/BnwgU=
=bjhZ
-----END PGP SIGNATURE-----
--=-=-=--

