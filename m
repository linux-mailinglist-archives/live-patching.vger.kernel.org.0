Return-Path: <live-patching+bounces-1905-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DAE10D06636
	for <lists+live-patching@lfdr.de>; Thu, 08 Jan 2026 23:01:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BAB04300BBB5
	for <lists+live-patching@lfdr.de>; Thu,  8 Jan 2026 21:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23AB333D4F8;
	Thu,  8 Jan 2026 21:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aoDmiWVO"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAB72DB796
	for <live-patching@vger.kernel.org>; Thu,  8 Jan 2026 21:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767909570; cv=none; b=XWoNDWObcfCYEpvk2mTXAVSyxO3X7QXf9N43/78mMJPKREMfG4m4svr9J5w+rAkhYVVD9bIePGLVQ/s8M5DhohrN0et4Uc2nZ4jXMsGc93KFRomO6Pco/dK00VWMvg3h4NPceoKH63FdFaKGe2Nw2M6tlnz3lX11hHvP0bbBLZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767909570; c=relaxed/simple;
	bh=n1FED02/isBAo+FWI/3dEX+dCgZVjigO1tqcVEgguH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRvRN/IPzlZq1IDPUEH/Y6nc4ckL/VW4ixAbzOuTwm1wUhDmTLrUPXvItFaYox75C3lvrCrD/5WDQGqZBDmW5dNLA5x1WsJIonoxglq5DpYFWvH5ihfC/wgHgyHU0WL1Vc6weWJWj5iJJM7ML5K3ulhZiCZEgFREquh3NybKq8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aoDmiWVO; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29f02651fccso24275ad.0
        for <live-patching@vger.kernel.org>; Thu, 08 Jan 2026 13:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767909568; x=1768514368; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=12l6ZAXCgEdEnz5LzVUFTc4+PbrdiKV8uTVIJz7Wh0g=;
        b=aoDmiWVOXhrZxxwP1Fqyrvqn37Mk5Rw9UqgKsWr3pV0IwUF5nSDtWDyGNnC/9wJHrK
         LWEkYe3mrRlN/Vpk7jOFa367Qi7wY0teOrHSIo7/TBi2495AXvMxm2/EDEnhzg6TfycK
         h2ijkw7pfCUNjoXA2Hddc8NRupHYyNuULS3SABX8Wqr18+yxGUKYYTsOnayV3mOXN2Am
         m6V/ryaOTEnmZFYEyXBUp2iQWVxLpXXUxxW8w0EmvK4qT4NvSgGwshWiZCIIT6gTzDn2
         kCSwq/c7U3ApfILuzNNzZZvUShKfPEpkxSR7JJ+F3sKSpAqnQohZk+yHMT9t8Mt9Ui4A
         t74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767909568; x=1768514368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=12l6ZAXCgEdEnz5LzVUFTc4+PbrdiKV8uTVIJz7Wh0g=;
        b=n2uoLBcaWI77xudnXGG6uJktYxXNiAZtBbJGI27qHbCvSMysL+aDGfGucHK4OcLH/s
         63eI7YcHeoUL5CNsq2a3EGiiO8Dxl6gLALh1W6kn1MRukRByhV1oD+z4qYTpmpOOrj4b
         QnrqnbCDVaRKHiPaUQNVRIyRABmk66bWGeADySEcQPy3U1tMKIfP2IRpQLoctx3AMWn0
         r5Ufd0ZLO/HWTDgwACqlAJiHD4QQyfoSl85aM/MTX+DAJxMfUb1ot3x3BJOvvsgB0Thc
         mKoL9Oa7pYiixzzpNE3FjV0BTpAfv9uLxmhv3o2GkDZ2ak2MxN0lCr7wm4TZDXr3kVYk
         N/Kg==
X-Forwarded-Encrypted: i=1; AJvYcCW4LGHtL40DEvY8BnWhWrA84ib3CF3z/OhGAXeISZerUDzuMhFUaBLRDmunzSI05+xeCTGpH8N8OUziss4q@vger.kernel.org
X-Gm-Message-State: AOJu0YyjY7GHfdKn5S6wCtR3pm0Jb7ImiMQbhDLLM/9axdBgOno+BaD3
	rmgdaZPHvHyMjgGkbZzI7ekFh3z/SEpGEEOMjj4jdx7ykkUgELHbkJeCKelzCV828w==
X-Gm-Gg: AY/fxX5EH+JbsqqYS+dKxCQPvIa5JAQQ4UfTv/LuHehm/imesRxCRx60rBgBLxiLDnd
	K7D3kwn0jvFCTJlN/skxfgGf59hxQr7bfh0ziF4sNvGO5rHLhPyLXZKUmkgIX62OINUMQt6Hsny
	nN2agpOBBO6xTzGE0MKzYOZIJBcf6S4gHOSuxVkp2OexKlJLcxb6t47vOIedVFJLsorfoFLNMLZ
	hZuBQ5BKw4WFkbCtl/LilJUiEHFp4s6fIRaKJdgxe+Cvi3nh2YQT8v94fX7O4hGSmSL/hpeCQXq
	V+8xKD3U6ZbpOwrBQ3tletL6pOOkP2xidxHjHL9EGdd5pMRpfUV++ayG3kJGrTNfHpAEWkCEsvC
	G/nRM5KcJgC4Xof4myAHcGI84Co1y7x+qqUlUi5e6uD4ZuPkjL2mUDuj4aM0Cg4bqY5LmCd806z
	ehNtSRnh2xpq8hKxe86e96P4zytkiNn8NxF2eZuBa62Kx3kzPuRw==
X-Received: by 2002:a17:902:db02:b0:2a1:35df:250f with SMTP id d9443c01a7336-2a40a985c51mr369485ad.15.1767909567697;
        Thu, 08 Jan 2026 13:59:27 -0800 (PST)
Received: from google.com (210.53.125.34.bc.googleusercontent.com. [34.125.53.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd3632sm88131445ad.95.2026.01.08.13.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 13:59:27 -0800 (PST)
Date: Thu, 8 Jan 2026 21:59:21 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
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
Message-ID: <aWAouZSH0Zw39Qt3@google.com>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <97d8b7710a8f5389e323d0933dec68888fec5f1f.1758067942.git.jpoimboe@kernel.org>
 <aUbODsjSuIBBLyo_@google.com>
 <aV2QyUv3-8SLV6Z8@willie-the-truck>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV2QyUv3-8SLV6Z8@willie-the-truck>

On Tue, Jan 06, 2026 at 10:46:33PM +0000, Will Deacon wrote:
> On Sat, Dec 20, 2025 at 04:25:50PM +0000, Carlos Llamas wrote:
> > On Wed, Sep 17, 2025 at 09:03:10AM -0700, Josh Poimboeuf wrote:
> > > TEXT_MAIN, DATA_MAIN and friends are defined differently depending on
> > > whether certain config options enable -ffunction-sections and/or
> > > -fdata-sections.
> > > 
> > > There's no technical reason for that beyond voodoo coding.  Keeping the
> > > separate implementations adds unnecessary complexity, fragments the
> > > logic, and increases the risk of subtle bugs.
> > > 
> > > Unify the macros by using the same input section patterns across all
> > > configs.
> > > 
> > > This is a prerequisite for the upcoming livepatch klp-build tooling
> > > which will manually enable -ffunction-sections and -fdata-sections via
> > > KCFLAGS.
> > > 
> > > Cc: Heiko Carstens <hca@linux.ibm.com>
> > > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > > Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > ---
> > >  include/asm-generic/vmlinux.lds.h | 40 ++++++++++---------------------
> > >  scripts/module.lds.S              | 12 ++++------
> > >  2 files changed, 17 insertions(+), 35 deletions(-)
> 
> [...]
> 
> > I'm seeing some KP when trying to load modules after this change. I
> > believe there is some sort of incompatibility with the SCS (Shadow Call
> > Stack) code in arm64? The panic is always on __pi_scs_handle_fde_frame:
> > 
> >   init: Loading module [...]/drivers/net/wireless/virtual/mac80211_hwsim.ko
> >   Unable to handle kernel paging request at virtual address ffffffe6468f0ffc
> >   [...]
> 
> nit: please don't trim the useful stuff when reporting a crash!
> 
> >   pc : __pi_scs_handle_fde_frame+0xd8/0x15c
> >   lr : __pi_$x+0x74/0x138
> >   sp : ffffffc08005bb10
> >   x29: ffffffc08005bb10 x28: ffffffc081873010 x27: 0000000000000000
> >   x26: 0000000000000007 x25: 0000000000000000 x24: 0000000000000000
> >   x23: 0000000000000001 x22: ffffffe649794fa0 x21: ffffffe6469190b4
> >   x20: 000000000000182c x19: 0000000000000001 x18: ffffffc080053000
> >   x17: 000000000000002d x16: ffffffe6469190c5 x15: ffffffe6468f1000
> >   x14: 000000000000003e x13: ffffffe6469190c6 x12: 00000000d50323bf
> >   x11: 00000000d503233f x10: ffffffe649119cb8 x9 : ffffffe6468f1000
> >   x8 : 0000000000000100 x7 : 00656d6172665f68 x6 : 0000000000000001
> >   x5 : 6372610000000000 x4 : 0000008000000000 x3 : 0000000000000000
> >   x2 : ffffffe647e528f4 x1 : 0000000000000001 x0 : 0000000000000004
> >   Call trace:
> >    __pi_scs_handle_fde_frame+0xd8/0x15c (P)
> >    module_finalize+0xfc/0x164
> >    post_relocation+0xbc/0xd8
> >    load_module+0xfd4/0x11a8
> >    __arm64_sys_finit_module+0x23c/0x328
> >    invoke_syscall+0x58/0xe4
> >    el0_svc_common+0x80/0xdc
> >    do_el0_svc+0x1c/0x28
> >    el0_svc+0x54/0x1c4
> >    el0t_64_sync_handler+0x68/0xdc
> >    el0t_64_sync+0x1c4/0x1c8
> >   Code: 54fffd4c 1400001f 3707ff63 aa0903ef (b85fcdf0)
> 
> Hmm, looks like a translation fault from the load buried here:
> 
> 	u32 insn = le32_to_cpup((void *)loc);
> 
> in scs_patch_loc(), called from the 'DW_CFA_negate_ra_state' case in
> scs_handle_fde_frame(). So presumably 'loc' is bogus.
> 
> Since you replied to this patch, does reverting it fix the problem for
> you?

Yes, but it is only coincidental. The real issue seems to be with our
toolchain. I'll start looking there instead. Sorry for the noise.

--
Carlos Llamas

