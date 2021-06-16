Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2A53A8E97
	for <lists+live-patching@lfdr.de>; Wed, 16 Jun 2021 03:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFPByJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Jun 2021 21:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhFPByI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Jun 2021 21:54:08 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD159C061574;
        Tue, 15 Jun 2021 18:52:03 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id w31so646230pga.6;
        Tue, 15 Jun 2021 18:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SYAZiKhu2cUPFls/xCgRwEt5H3IOQudDC2d2SMNfX8s=;
        b=tlwwglVZtYsipluaBFVpfWks6ENBb6VU0iFSnteE3nzK+y1kuem4YIfWfhTgUbgAmh
         xHErugfjlb/QUH7t2RDNjYYgSyiSQ9x2hfyb/8aA+LbPJFmhK854tvPnkoIp7zuXLCLV
         AEZSDDYo7azBdclJ5BOSonknsp5XAHaAmUi+n3iNDVcvxwRhbmMMoVMTaSM/Fmia0NS5
         wRX1GH/Q6g+awuiW1oBoDNL0GXPWUF7XkL5RXWg7nheuEGdyaCWv03EIApuV0pUJhwmL
         ZZjlyJU+hLJX+FcDu5QNj45DiyEiHMqyKYqKRGP1U1Xno7P9KIj/7e/IzKhnVafHPxwA
         IL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SYAZiKhu2cUPFls/xCgRwEt5H3IOQudDC2d2SMNfX8s=;
        b=Ab5qzXp9cb+FIANXc0mWXb9UeP4lOPjqzOCj5wfflLgO329XlP2Q6PJk9243tqZxA/
         CZdkQVPQaQ5F6T52ARZlXom5DvS8aJiP0pJAQ0jCb0ozwncTQx53cpUGMv/ezmvUJucY
         shWh92CHZFKSgeSnN4NONXI56A7ntrl82QZqvf3QKnypNebqNGYzcKqe57toa49yU1qC
         lZJoHc9pVjYPsk3xwZb64i3VWoUKwf79CDwTLghto9ZckQU+tDuzEoSzv7W63kGetKBy
         Sj4E7picNmpW6KyyBjKpIyMEKGAJ7HEFtf6dUgIymd+hTAhTTKr0g8USCHaOaX7cpZno
         RF1A==
X-Gm-Message-State: AOAM5332T0EXzcvaoQ6Iw8hUcKTAb0G3TJAeaLbrwAuN1KiFiYVrH6iu
        HW6U7EEuSHqoerg+rQuU/OM=
X-Google-Smtp-Source: ABdhPJxTguLZTyee9M/iAjORC96v1PnwIMeyIKIZKeZzSHQ6/GXDMDaCa6prXtWLjoLl3QrHo9tkig==
X-Received: by 2002:a63:78d:: with SMTP id 135mr2539279pgh.178.1623808323335;
        Tue, 15 Jun 2021 18:52:03 -0700 (PDT)
Received: from u3c3f5cfe23135f.ant.amazon.com (97-113-131-35.tukw.qwest.net. [97.113.131.35])
        by smtp.googlemail.com with ESMTPSA id q21sm3459664pjg.43.2021.06.15.18.52.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Jun 2021 18:52:02 -0700 (PDT)
Message-ID: <712b44d2af8f8cd3199aad87eb3bc94ea22d6f4a.camel@gmail.com>
Subject: Re: [RFC PATCH v5 2/2] arm64: Create a list of SYM_CODE functions,
 check return PC against list
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     madvenka@linux.microsoft.com, broonie@kernel.org,
        mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 15 Jun 2021 18:52:01 -0700
In-Reply-To: <20210526214917.20099-3-madvenka@linux.microsoft.com>
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
         <20210526214917.20099-1-madvenka@linux.microsoft.com>
         <20210526214917.20099-3-madvenka@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 2021-05-26 at 16:49 -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> The unwinder should check if the return PC falls in any function that
> is considered unreliable from an unwinding perspective. If it does,
> mark the stack trace unreliable.
> 

[snip]

Correct me if I'm wrong, but do you not need to move the final frame
check to before the unwinder_is_unreliable() call?

Userland threads which have ret_from_fork as the last entry on the
stack will always be marked unreliable as they will always have a
SYM_CODE entry on their stack (the ret_from_fork).

Also given that this means the last frame has been reached and as such
there's no more unwinding to do, I don't think we care if the last pc
is a code address.

- Suraj

>   *
> @@ -133,7 +236,20 @@ int notrace unwind_frame(struct task_struct
> *tsk, struct stackframe *frame)
>  	 *	- Foreign code (e.g. EFI runtime services)
>  	 *	- Procedure Linkage Table (PLT) entries and veneer
> functions
>  	 */
> -	if (!__kernel_text_address(frame->pc))
> +	if (!__kernel_text_address(frame->pc)) {
> +		frame->reliable = false;
> +		return 0;
> +	}
> +
> +	/*
> +	 * If the final frame has been reached, there is no more
> unwinding
> +	 * to do. There is no need to check if the return PC is
> considered
> +	 * unreliable by the unwinder.
> +	 */
> +	if (!frame->fp)
> +		return 0;

if (frame->fp == (unsigned long)task_pt_regs(tsk)->stackframe)
	return -ENOENT;

> +
> +	if (unwinder_is_unreliable(frame->pc))
>  		frame->reliable = false;
>  
>  	return 0;
> diff --git a/arch/arm64/kernel/vmlinux.lds.S
> b/arch/arm64/kernel/vmlinux.lds.S
> index 7eea7888bb02..32e8d57397a1 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -103,6 +103,12 @@ jiffies = jiffies_64;
>  #define TRAMP_TEXT
>  #endif
>  
> +#define SYM_CODE_FUNCTIONS                                     \
> +       . = ALIGN(16);                                           \
> +       __sym_code_functions_start = .;                         \
> +       KEEP(*(sym_code_functions))                             \
> +       __sym_code_functions_end = .;
> +
>  /*
>   * The size of the PE/COFF section that covers the kernel image,
> which
>   * runs from _stext to _edata, must be a round multiple of the
> PE/COFF
> @@ -218,6 +224,7 @@ SECTIONS
>  		CON_INITCALL
>  		INIT_RAM_FS
>  		*(.init.altinstructions .init.bss)	/* from the
> EFI stub */
> +               SYM_CODE_FUNCTIONS
>  	}
>  	.exit.data : {
>  		EXIT_DATA

