Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3824F447D3B
	for <lists+live-patching@lfdr.de>; Mon,  8 Nov 2021 11:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhKHKEY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 8 Nov 2021 05:04:24 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:60350 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238568AbhKHKES (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 8 Nov 2021 05:04:18 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 33A1E21AFC;
        Mon,  8 Nov 2021 10:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636365693; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5UZuKAmHIrwVcGr41lKYOAKA0vOHUe0ZexZ00mvExQU=;
        b=D3eL8PObhxrU8IE4pU3nDbNQgS4xDX279ndrDe7NVbcOlV4CWeQKYLEcilP1qhzGBDs3uI
        HmnxAMflpuaiiXUcslsjCPMak5CL4TWeHpLVKyz19GO9CWWroehg4VuHCTyaaSS/gDVgxR
        wrpGSrPqJ5HNIFgpWfuGeQ6v/SzYcyk=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 11789A3B8B;
        Mon,  8 Nov 2021 10:01:33 +0000 (UTC)
Date:   Mon, 8 Nov 2021 11:01:32 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v1 5/5] powerpc/ftrace: Add support for livepatch to PPC32
Message-ID: <YYj1fNkYAqr/H/I2@alley>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
 <b73d053c145245499511c4827890c9411c8b3a5a.1635423081.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b73d053c145245499511c4827890c9411c8b3a5a.1635423081.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-10-28 14:24:05, Christophe Leroy wrote:
> This is heavily copied from PPC64. Not much to say about it.
> 
> Livepatch sample modules all work.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
> diff --git a/arch/powerpc/include/asm/livepatch.h b/arch/powerpc/include/asm/livepatch.h
> index 4fe018cc207b..daf24d837241 100644
> --- a/arch/powerpc/include/asm/livepatch.h
> +++ b/arch/powerpc/include/asm/livepatch.h
> @@ -23,8 +23,8 @@ static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
>  static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
>  {
>  	/*
> -	 * Live patch works only with -mprofile-kernel on PPC. In this case,
> -	 * the ftrace location is always within the first 16 bytes.
> +	 * Live patch works on PPC32 and only with -mprofile-kernel on PPC64. In
> +	 * both cases, the ftrace location is always within the first 16 bytes.

Nit: I had some problems to parse it. I wonder if the following is
better:

	 * Live patch works on PPC32 out of box and on PPC64 only with
	 * -mprofile-kernel. In both cases, the ftrace location is always
	 * within the first 16 bytes.


>  	 */
>  	return ftrace_location_range(faddr, faddr + 16);
>  }

Best Regards,
Petr
