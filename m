Return-Path: <live-patching+bounces-1904-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF23ACFB494
	for <lists+live-patching@lfdr.de>; Tue, 06 Jan 2026 23:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 184333043F4A
	for <lists+live-patching@lfdr.de>; Tue,  6 Jan 2026 22:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE41B2E1C6B;
	Tue,  6 Jan 2026 22:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kkpvGXGQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C3741C63;
	Tue,  6 Jan 2026 22:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767739601; cv=none; b=hpxe/Moecg4Pu0T/VWJ4j6OPpcl4RW8qJyTsTTwjuGdk3DDWxzzxopviywSSBNs6XChY6HSYAr1/ex3rMS5J1D1fPUwww6RsUW6pODRo5izBDJcKIAokqdyT6fiyy9bV5n1C7pwG1t+ePV7bjSet23oQybezFMRNbgWst4TN8c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767739601; c=relaxed/simple;
	bh=UcAH6kUDDLcZ1pjaXxBLw0+BGwMdEgdT/zwICrUMwXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EBrE2RR6SWRywPdk2VnW5wP9tmtpTVt5erNFN82xmzaj80ikN48nzyaP1bqsu3YB8w0hJTWK/bz1zLeRq9dpMROcctPQN86O/fPqzvwnWAgEtGOmCR5ftQ3ORXve4SA61TVZ11IODVslqowV7zdlQ7/SwIUo/1wlN4G4ySKvj18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kkpvGXGQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D420AC116C6;
	Tue,  6 Jan 2026 22:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767739601;
	bh=UcAH6kUDDLcZ1pjaXxBLw0+BGwMdEgdT/zwICrUMwXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kkpvGXGQaaldNeYz3N9ZKwrKSrxJHLJNaFpBi9jAnV1wcrkI5zXcdlZba6ybcpqJF
	 +CnhmwQIjlCuYmel2n+xnLsj7uycXBRaeeGU/Guh5NjCVlPDtWnVcb0JMxkKvr3izB
	 KGG/YPjwmxSIsW9JpbquX2qgLz1pK7X01q0Z/OQxg9y+ww5Ec8/YnRX8I8NvYxumCZ
	 cu5NHVhQR/BLvE6M3xQ7TcrLQBSKp485aClVJDOkhaGY9NKtuOjMBIe1PVuorcUyXj
	 XpZymafIedHaKpTmhg49rfRrmoLs/S8DR0FcjLJw6fAjLpwmwudqevjEHmHP15zcdN
	 plYFQM6ZBj/QQ==
Date: Tue, 6 Jan 2026 22:46:33 +0000
From: Will Deacon <will@kernel.org>
To: Carlos Llamas <cmllamas@google.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sami Tolvanen <samitolvanen@google.com>, kernel-team@android.com
Subject: Re: [PATCH v4 02/63] vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and
 related macros
Message-ID: <aV2QyUv3-8SLV6Z8@willie-the-truck>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <97d8b7710a8f5389e323d0933dec68888fec5f1f.1758067942.git.jpoimboe@kernel.org>
 <aUbODsjSuIBBLyo_@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUbODsjSuIBBLyo_@google.com>

On Sat, Dec 20, 2025 at 04:25:50PM +0000, Carlos Llamas wrote:
> On Wed, Sep 17, 2025 at 09:03:10AM -0700, Josh Poimboeuf wrote:
> > TEXT_MAIN, DATA_MAIN and friends are defined differently depending on
> > whether certain config options enable -ffunction-sections and/or
> > -fdata-sections.
> > 
> > There's no technical reason for that beyond voodoo coding.  Keeping the
> > separate implementations adds unnecessary complexity, fragments the
> > logic, and increases the risk of subtle bugs.
> > 
> > Unify the macros by using the same input section patterns across all
> > configs.
> > 
> > This is a prerequisite for the upcoming livepatch klp-build tooling
> > which will manually enable -ffunction-sections and -fdata-sections via
> > KCFLAGS.
> > 
> > Cc: Heiko Carstens <hca@linux.ibm.com>
> > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  include/asm-generic/vmlinux.lds.h | 40 ++++++++++---------------------
> >  scripts/module.lds.S              | 12 ++++------
> >  2 files changed, 17 insertions(+), 35 deletions(-)

[...]

> I'm seeing some KP when trying to load modules after this change. I
> believe there is some sort of incompatibility with the SCS (Shadow Call
> Stack) code in arm64? The panic is always on __pi_scs_handle_fde_frame:
> 
>   init: Loading module [...]/drivers/net/wireless/virtual/mac80211_hwsim.ko
>   Unable to handle kernel paging request at virtual address ffffffe6468f0ffc
>   [...]

nit: please don't trim the useful stuff when reporting a crash!

>   pc : __pi_scs_handle_fde_frame+0xd8/0x15c
>   lr : __pi_$x+0x74/0x138
>   sp : ffffffc08005bb10
>   x29: ffffffc08005bb10 x28: ffffffc081873010 x27: 0000000000000000
>   x26: 0000000000000007 x25: 0000000000000000 x24: 0000000000000000
>   x23: 0000000000000001 x22: ffffffe649794fa0 x21: ffffffe6469190b4
>   x20: 000000000000182c x19: 0000000000000001 x18: ffffffc080053000
>   x17: 000000000000002d x16: ffffffe6469190c5 x15: ffffffe6468f1000
>   x14: 000000000000003e x13: ffffffe6469190c6 x12: 00000000d50323bf
>   x11: 00000000d503233f x10: ffffffe649119cb8 x9 : ffffffe6468f1000
>   x8 : 0000000000000100 x7 : 00656d6172665f68 x6 : 0000000000000001
>   x5 : 6372610000000000 x4 : 0000008000000000 x3 : 0000000000000000
>   x2 : ffffffe647e528f4 x1 : 0000000000000001 x0 : 0000000000000004
>   Call trace:
>    __pi_scs_handle_fde_frame+0xd8/0x15c (P)
>    module_finalize+0xfc/0x164
>    post_relocation+0xbc/0xd8
>    load_module+0xfd4/0x11a8
>    __arm64_sys_finit_module+0x23c/0x328
>    invoke_syscall+0x58/0xe4
>    el0_svc_common+0x80/0xdc
>    do_el0_svc+0x1c/0x28
>    el0_svc+0x54/0x1c4
>    el0t_64_sync_handler+0x68/0xdc
>    el0t_64_sync+0x1c4/0x1c8
>   Code: 54fffd4c 1400001f 3707ff63 aa0903ef (b85fcdf0)

Hmm, looks like a translation fault from the load buried here:

	u32 insn = le32_to_cpup((void *)loc);

in scs_patch_loc(), called from the 'DW_CFA_negate_ra_state' case in
scs_handle_fde_frame(). So presumably 'loc' is bogus.

Since you replied to this patch, does reverting it fix the problem for
you?

> This is not a problem if I disable UNWIND_PATCH_PAC_INTO_SCS but I have
> no idea why.

Well, that avoids compiling the code that's crashing :p

> Looking around it seems like this might related:
> 
>   $ cat arch/arm64/include/asm/module.lds.h
>   SECTIONS {
>   [...]
>   #ifdef CONFIG_UNWIND_TABLES
>         /*
>          * Currently, we only use unwind info at module load time, so we can
>          * put it into the .init allocation.
>          */
>         .init.eh_frame : { *(.eh_frame) }
>   #endif

This patch doesn't seem to change that though?

Ard, do you have any ideas here? I wonder whether the addition of
support for 64-bit offsets in 60de7a647fc5 ("arm64/scs: Deal with 64-bit
relative offsets in FDE frames") has introduced padding/alignment
requirements into 'struct eh_frame' and we end up off-by-4 for 'loc' or
something like that? The faulting address looks like an underflow.

Will

