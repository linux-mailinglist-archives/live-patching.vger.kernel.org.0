Return-Path: <live-patching+bounces-1903-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B0BCD3380
	for <lists+live-patching@lfdr.de>; Sat, 20 Dec 2025 17:26:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D42553009777
	for <lists+live-patching@lfdr.de>; Sat, 20 Dec 2025 16:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4452278165;
	Sat, 20 Dec 2025 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jW1BTGfl"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E112F1DFD8B
	for <live-patching@vger.kernel.org>; Sat, 20 Dec 2025 16:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766247959; cv=none; b=TiboVL0PNVGjv84okdvF6tij6UU5/V+/v7amreWxX6fTcKg5lTPajJXi/kQqUZ/eVLkPjhK//e8yOm5WSjUR5T/0qDONTxmQAxn5Bvg85s+VqNRlspDI6uMFBGrdfwm0WUhXujyel0Lu5h0ppBVIsAksCUPt+dA65PH1Sfam7XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766247959; c=relaxed/simple;
	bh=3Tk0x5Yi8xw8InFvoeTF47nHAZKKlFvvhIhI4xItLWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khZXq2PKz+mYGPyHMey60wFgZxwMYMUbQEL1gXBqTdrWHkfHUFBUk7D9mG1ljPozInFGOi6B8CGe1s/eFu4A/J/KcNLak08+xXkYmNmhnd+dkgXJ2/cpTrRMY5cMApRQ9JsV7uDoYkT7hGgasJVlvpOqAQgehKLuT/Zh+EZDMpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jW1BTGfl; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a1462573caso342625ad.0
        for <live-patching@vger.kernel.org>; Sat, 20 Dec 2025 08:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766247957; x=1766852757; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gIQjLPFx93IqGyXDV26GtjMmnQfF+osjIdr5HpBFAa0=;
        b=jW1BTGflo7mx3IqYwT2zXW56/20lrtBK19BN9gr8PQk+jcLpmN69uX9d33Y0lGpulC
         K4xp6Fvp9Qu3p5QEuQcdbNNW5OWRKWA8n9lI0+Ert9uaEpN/9UiDDIMh8ZvzHGwdtQDU
         qWJuN7b9EunAMSJoCZueYBWJj0LYO8VTy0eiLMbH85q/ZnGh8Kd/xsQMxzee8NUZBV9L
         ovF7wKZ7uaoSDwll2bmJERYRruWkYuwVBYq0zH3ZIFGFM4l++GbCYvmTNJJBf5TwqlQB
         KweXK58448DXqy8JPTf5LGCtPhtxKM3+c18yo6yuuPxDMu6E9WY5aJa7d8o2c82mxD71
         2fVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766247957; x=1766852757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gIQjLPFx93IqGyXDV26GtjMmnQfF+osjIdr5HpBFAa0=;
        b=FjyRdJMVts0i5gL5KzDF4tYJlLcYLX8w1MxSV5OLVq1m5s/SxdjE0glEw6MwH0FOU7
         rfeZcwwekw28tglVXLAU+bYpE9c57sR9f8NU6euLVZdOR+borHduhRigjOGc8qa5H9BT
         XLEm6gFm4/J+zr7GavUZfHr0KogpWXXOJuppZuzBmVnUbyxzJL2joL6sTv7z3agazfcG
         NKBtxQgVNCExw0VV5Vsb7Hr/r9PHiw1jmkqW4OEmYOXRkhsJ7/bNFVHHt5ysHuzv7Clq
         GHRPxmTT/Qkie+EJ8VlRzBzYO/c8zcBsfGwLVLQuvlH/GWpwe9HbP0l139M1jQCZinu4
         wCTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFrFcBrj7EZOaJffsKgPie3EJPJU2Tl2xW90SEh1ZaYv/Hkod2rmDNSOPkvrcDqxg5T6PXPtgC7aSdZslh@vger.kernel.org
X-Gm-Message-State: AOJu0YzYSDka8IABId9d6shhvfztgPFnpPhFm9n3tnu8iAtfSVaDpTel
	xybnrLSQFhEb7pjwLZucCxNY0vU+5NfhMUurKQGNbxrY+HnvteNrDSUQbX3pTLegAA==
X-Gm-Gg: AY/fxX4D7CTb6SF4xGdotfHo1c/LJTY5r6qZcknMCwx6VsZEBKA/0g0gXOEq3Wd+mFa
	NjKNiPHawEewdDaADXDI8mrAqV6R/uXZliijLk+tZCirV3fX0C9y+YBefVZQbr9pyuSEe67Aomm
	bnqgPWzmlAZXzGB071abB2U27JeJkHMurvdt+LPUYAvHQzcA/erN8hTWI/MNmrwugqk7j1DibrR
	Pel99tcL+6QbcuZZhcOSw680Apc2IPBQvl+tPDEGl4I2fEJ45n9I04rVEC3PL9aBzwh+AI9VDSs
	yBXPOvJYTP9/0q5nCRCsrQnkgawaVskgy7akQe4cUZwXCfUcyymAT8p++L2HssDccCvdiLosGta
	lvg272QmFEVAaMAAJGYweh3Q2bvYOTBtIVxV+iPY2454uwmuMoiSt+ehafOvV6Dk1KZmoK/lEvl
	6vcMwoHJglREAox15zpPms5ca55sS/Us76A15EeiBvUyocomxLoA==
X-Google-Smtp-Source: AGHT+IGzCyTbAcnQMAGsAbsKZObqi7Zo42UE6ej6bnadd0H88dY0R2dMum2jvnbIwGltm3YDpfLPlA==
X-Received: by 2002:a17:903:380f:b0:290:cd63:e922 with SMTP id d9443c01a7336-2a3142c95c9mr1128595ad.15.1766247956677;
        Sat, 20 Dec 2025 08:25:56 -0800 (PST)
Received: from google.com (129.35.125.34.bc.googleusercontent.com. [34.125.35.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c74490sm53359015ad.5.2025.12.20.08.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Dec 2025 08:25:56 -0800 (PST)
Date: Sat, 20 Dec 2025 16:25:50 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
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
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH v4 02/63] vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and
 related macros
Message-ID: <aUbODsjSuIBBLyo_@google.com>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <97d8b7710a8f5389e323d0933dec68888fec5f1f.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97d8b7710a8f5389e323d0933dec68888fec5f1f.1758067942.git.jpoimboe@kernel.org>

On Wed, Sep 17, 2025 at 09:03:10AM -0700, Josh Poimboeuf wrote:
> TEXT_MAIN, DATA_MAIN and friends are defined differently depending on
> whether certain config options enable -ffunction-sections and/or
> -fdata-sections.
> 
> There's no technical reason for that beyond voodoo coding.  Keeping the
> separate implementations adds unnecessary complexity, fragments the
> logic, and increases the risk of subtle bugs.
> 
> Unify the macros by using the same input section patterns across all
> configs.
> 
> This is a prerequisite for the upcoming livepatch klp-build tooling
> which will manually enable -ffunction-sections and -fdata-sections via
> KCFLAGS.
> 
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  include/asm-generic/vmlinux.lds.h | 40 ++++++++++---------------------
>  scripts/module.lds.S              | 12 ++++------
>  2 files changed, 17 insertions(+), 35 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index ae2d2359b79e9..6b2311fa41393 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -87,39 +87,24 @@
>  #define ALIGN_FUNCTION()  . = ALIGN(CONFIG_FUNCTION_ALIGNMENT)
>  
>  /*
> - * LD_DEAD_CODE_DATA_ELIMINATION option enables -fdata-sections, which
> - * generates .data.identifier sections, which need to be pulled in with
> - * .data. We don't want to pull in .data..other sections, which Linux
> - * has defined. Same for text and bss.
> + * Support -ffunction-sections by matching .text and .text.*,
> + * but exclude '.text..*'.
>   *
> - * With LTO_CLANG, the linker also splits sections by default, so we need
> - * these macros to combine the sections during the final link.
> - *
> - * With AUTOFDO_CLANG and PROPELLER_CLANG, by default, the linker splits
> - * text sections and regroups functions into subsections.
> - *
> - * RODATA_MAIN is not used because existing code already defines .rodata.x
> - * sections to be brought in with rodata.
> + * Special .text.* sections that are typically grouped separately, such as
> + * .text.unlikely or .text.hot, must be matched explicitly before using
> + * TEXT_MAIN.
>   */
> -#if defined(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION) || defined(CONFIG_LTO_CLANG) || \
> -defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>  #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
> -#else
> -#define TEXT_MAIN .text
> -#endif
> -#if defined(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION) || defined(CONFIG_LTO_CLANG)
> +
> +/*
> + * Support -fdata-sections by matching .data, .data.*, and others,
> + * but exclude '.data..*'.
> + */
>  #define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data.rel.* .data..L* .data..compoundliteral* .data.$__unnamed_* .data.$L*
>  #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
>  #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]* .rodata..L*
>  #define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..L* .bss..compoundliteral*
>  #define SBSS_MAIN .sbss .sbss.[0-9a-zA-Z_]*
> -#else
> -#define DATA_MAIN .data .data.rel .data.rel.local
> -#define SDATA_MAIN .sdata
> -#define RODATA_MAIN .rodata
> -#define BSS_MAIN .bss
> -#define SBSS_MAIN .sbss
> -#endif
>  
>  /*
>   * GCC 4.5 and later have a 32 bytes section alignment for structures.
> @@ -580,9 +565,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>   * during second ld run in second ld pass when generating System.map
>   *
>   * TEXT_MAIN here will match symbols with a fixed pattern (for example,
> - * .text.hot or .text.unlikely) if dead code elimination or
> - * function-section is enabled. Match these symbols first before
> - * TEXT_MAIN to ensure they are grouped together.
> + * .text.hot or .text.unlikely).  Match those before TEXT_MAIN to ensure
> + * they get grouped together.
>   *
>   * Also placing .text.hot section at the beginning of a page, this
>   * would help the TLB performance.
> diff --git a/scripts/module.lds.S b/scripts/module.lds.S
> index ee79c41059f3d..2632c6cb8ebe7 100644
> --- a/scripts/module.lds.S
> +++ b/scripts/module.lds.S
> @@ -38,12 +38,10 @@ SECTIONS {
>  	__kcfi_traps 		: { KEEP(*(.kcfi_traps)) }
>  #endif
>  
> -#ifdef CONFIG_LTO_CLANG
> -	/*
> -	 * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
> -	 * -ffunction-sections, which increases the size of the final module.
> -	 * Merge the split sections in the final binary.
> -	 */
> +	.text : {
> +		*(.text .text.[0-9a-zA-Z_]*)
> +	}
> +

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>

I'm seeing some KP when trying to load modules after this change. I
believe there is some sort of incompatibility with the SCS (Shadow Call
Stack) code in arm64? The panic is always on __pi_scs_handle_fde_frame:

  init: Loading module [...]/drivers/net/wireless/virtual/mac80211_hwsim.ko
  Unable to handle kernel paging request at virtual address ffffffe6468f0ffc
  [...]
  pc : __pi_scs_handle_fde_frame+0xd8/0x15c
  lr : __pi_$x+0x74/0x138
  sp : ffffffc08005bb10
  x29: ffffffc08005bb10 x28: ffffffc081873010 x27: 0000000000000000
  x26: 0000000000000007 x25: 0000000000000000 x24: 0000000000000000
  x23: 0000000000000001 x22: ffffffe649794fa0 x21: ffffffe6469190b4
  x20: 000000000000182c x19: 0000000000000001 x18: ffffffc080053000
  x17: 000000000000002d x16: ffffffe6469190c5 x15: ffffffe6468f1000
  x14: 000000000000003e x13: ffffffe6469190c6 x12: 00000000d50323bf
  x11: 00000000d503233f x10: ffffffe649119cb8 x9 : ffffffe6468f1000
  x8 : 0000000000000100 x7 : 00656d6172665f68 x6 : 0000000000000001
  x5 : 6372610000000000 x4 : 0000008000000000 x3 : 0000000000000000
  x2 : ffffffe647e528f4 x1 : 0000000000000001 x0 : 0000000000000004
  Call trace:
   __pi_scs_handle_fde_frame+0xd8/0x15c (P)
   module_finalize+0xfc/0x164
   post_relocation+0xbc/0xd8
   load_module+0xfd4/0x11a8
   __arm64_sys_finit_module+0x23c/0x328
   invoke_syscall+0x58/0xe4
   el0_svc_common+0x80/0xdc
   do_el0_svc+0x1c/0x28
   el0_svc+0x54/0x1c4
   el0t_64_sync_handler+0x68/0xdc
   el0t_64_sync+0x1c4/0x1c8
  Code: 54fffd4c 1400001f 3707ff63 aa0903ef (b85fcdf0)

This is not a problem if I disable UNWIND_PATCH_PAC_INTO_SCS but I have
no idea why. Looking around it seems like this might related:

  $ cat arch/arm64/include/asm/module.lds.h
  SECTIONS {
  [...]
  #ifdef CONFIG_UNWIND_TABLES
        /*
         * Currently, we only use unwind info at module load time, so we can
         * put it into the .init allocation.
         */
        .init.eh_frame : { *(.eh_frame) }
  #endif

I must note that I've only seen this in Android kernels and I have not
tried to reproduce the issue elsewhere. However, the incompatibility
seems like it could be applicable upstream too and I'm hoping that the
issue is evident to others (I can't understand any of this).

Thanks,
--
Carlos Llamas

