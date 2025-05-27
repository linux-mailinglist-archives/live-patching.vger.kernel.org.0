Return-Path: <live-patching+bounces-1470-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D2DEAAC5140
	for <lists+live-patching@lfdr.de>; Tue, 27 May 2025 16:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9CB51886E03
	for <lists+live-patching@lfdr.de>; Tue, 27 May 2025 14:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3C88263C8F;
	Tue, 27 May 2025 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fXkCWeqk"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FA6279912
	for <live-patching@vger.kernel.org>; Tue, 27 May 2025 14:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748357222; cv=none; b=SHFG5DFhjZvT6hlzs+h9l59elrDhoRZeRy+KMSxK6uaRezOxNXmyRF/6V4JfLOL16H3XuvZtHOAdTe0q/ybApy68fMJgZtg1FvqTLOPkR/WZ8ULhoxA4qVJL8QRJ8LbMxM2vy7SmL+pSvjPBR9KfMnvQrSM8oQlOz4A3wUcPLtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748357222; c=relaxed/simple;
	bh=l5+jdrZUeY+xY/QoP3upiVatd7/akKxXdgz78QF8vwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bmxDCMlJH6TBrp76nHxtAF4Bu94t03foKbAjMSsfzwYPvaH9tviRwNEDHOVbaMp3Aq+yyPnXyAg5FK7G3kaqBhl46id06AAiIyabR9nToTV4zgi3RG6CXebXIdhmUBsBApdUrdR4Fyj45X0F5+PPU3U51RMTqn7fXwsQINqzuCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fXkCWeqk; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a4c9024117so2687940f8f.0
        for <live-patching@vger.kernel.org>; Tue, 27 May 2025 07:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1748357219; x=1748962019; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+7HDHtV9GJMKJoI+hQUJREBqkbUAnxxzKnn5VFH1x3c=;
        b=fXkCWeqkS6/UPA3SqnqeBuWUcIUX8WWCy2+mmOxE68HIaivQmWpKM+VMnFDJdoF4P/
         zg+yR+4Tu8tQYGZYC5FgSfi74gFeSAQvE2vstg7LpGCBPs8dd2sHgcV5kvI+MUU13WUc
         LmsyLEKFPU9Hd/37sAA/Nl2ejpcJIBaZapjpT5lEEskSJ6ldopUYWw682peJ507vWOJb
         AkjSOS3IKpdt2sb51xhXTNPpZDgQ8Un63tYB4ngJ2s1bXujE5csMQX8NO4D86x13DGW5
         WA+kLGSh5RHSfl8iBzIbcrBUHSWsWcqv/ps+0Sz+LXcJ6j1g1g5emDqLyG18c4tqDUdp
         6RxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748357219; x=1748962019;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7HDHtV9GJMKJoI+hQUJREBqkbUAnxxzKnn5VFH1x3c=;
        b=EztB51A3z7pENc2YJ3hHylcMkvFkAxldO5nB9EcgSJqp/DuvFK7W0H7iuYfORmoJMO
         muchrS3IvI+Lsva56UkTKLBfW1e3TNRpzmxJXPYTb5KVmazTL/gPy74MvjJDCm7Kke4O
         P8ctSABPEv5QIFcnOGKdXQ7qZfs1kTWh6JIhxyeV00dUluiM93xxCbApHRVOJuZGCk6s
         GCGrUAW+XbW/LsRja5dHlWRo0jizGaJRmPi/G/w7czK6w87IBeRZhU7SZHJgksgVvD6a
         WgNQZ2WeZsiVX+OxL7umJuZUnKSRnfd2ocD99BD2I472rJrXzmsGPKrxWHfLqPbaAqfA
         shVg==
X-Forwarded-Encrypted: i=1; AJvYcCXcY8t5mvNzsnruZMpuVXMx7VGwBruaDWCLajkw1sv++2z0Cl6ZdtH80wyw2RhKanm1/ggFLYLRo909qPIn@vger.kernel.org
X-Gm-Message-State: AOJu0YyIwHIbcHTYXphGHmzDEbf9Rbz2/EPtAbL/CJCtZiPEdGFodgzT
	vJcbO+HOZqMxanBB90uQ4IBGImo0SvZCnW0D4Fx5UPuYatjN3XDLJlH5u9Y5Nmo9hHI=
X-Gm-Gg: ASbGncslkTD0gKeUomkXscj3SfdScO3xRVVuoto7ElO4n30EV2eyca2x0lKWQHzMANG
	MXhdY0eS/2+LH4lJFBaajmRoBqck4suclFWVbM06v+l/QgKZf2LJvVmeYSDgowwKxuxTtfd392H
	JtiBRSF4gxdUbVhb7CY45D8SaS4yOmBHKVRH8yElzWu9qnid0gEJh0A1AVEPOyia/OyEL0MMbuA
	AIph9UuZnOy9tqB/M/kgFMkHVrttBAXsPoV6UqJWkS0FElX3rBPDnnOUsApFlD88aRUy2ZCcLKm
	gNE9NQr+X8gYBakrlLWgb9aWzbDSam7lzuZc6mvY0oF4e8WjezwNFSDHK9IVeA==
X-Google-Smtp-Source: AGHT+IH9rVBPyPZ2QD6bs1zmU6dNDHxpXwVBL+LkBhYI6uyPT74PmbS5+6ZQOEHAkczC1XbfLMJQEw==
X-Received: by 2002:a05:6000:1a8e:b0:3a3:7ba5:9a68 with SMTP id ffacd0b85a97d-3a4e5ebba5fmr781465f8f.18.1748357218605;
        Tue, 27 May 2025 07:46:58 -0700 (PDT)
Received: from pathway.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4d3332c01sm8385493f8f.92.2025.05.27.07.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 07:46:58 -0700 (PDT)
Date: Tue, 27 May 2025 16:46:56 +0200
From: Petr Mladek <pmladek@suse.com>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Toshiyuki Sato <fj6611ie@aa.jp.fujitsu.com>
Subject: Re: [PATCH v4 1/2] livepatch, x86/module: Generalize late module
 relocation locking.
Message-ID: <aDXQYMcLle2E_b2d@pathway.suse.cz>
References: <20250522205205.3408764-1-dylanbhatch@google.com>
 <20250522205205.3408764-2-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522205205.3408764-2-dylanbhatch@google.com>

On Thu 2025-05-22 20:52:04, Dylan Hatch wrote:
> Late module relocations are an issue on any arch that supports
> livepatch, so move the text_mutex locking to the livepatch core code.
> 
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> Acked-by: Song Liu <song@kernel.org>
> ---
>  arch/x86/kernel/module.c |  8 ++------
>  kernel/livepatch/core.c  | 18 +++++++++++++-----
>  2 files changed, 15 insertions(+), 11 deletions(-)
> 
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -197,18 +197,14 @@ static int write_relocate_add(Elf64_Shdr *sechdrs,
>  	bool early = me->state == MODULE_STATE_UNFORMED;
>  	void *(*write)(void *, const void *, size_t) = memcpy;
>  
> -	if (!early) {
> +	if (!early)
>  		write = text_poke;
> -		mutex_lock(&text_mutex);
> -	}
>  
>  	ret = __write_relocate_add(sechdrs, strtab, symindex, relsec, me,
>  				   write, apply);
>  
> -	if (!early) {
> +	if (!early)
>  		text_poke_sync();
> -		mutex_unlock(&text_mutex);
> -	}
>  
>  	return ret;
>  }
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 0e73fac55f8eb..9968441f73510 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -319,12 +320,19 @@ static int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>  					  sec, sec_objname);
>  		if (ret)
>  			return ret;
> -
> -		return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
>  	}
>  
> -	clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> -	return 0;
> +	if (!early)
> +		mutex_lock(&text_mutex);

I understand why you do this but it opens some questions.

As this patch suggests, the "text_mutex" has been used to
sychronize apply_relocate_add() only on x86_64 so far.

s390x seems to rely on "s390_kernel_write_lock" taken by:

  + apply_relocate_add()
    + s390_kernel_write()
      + __s390_kernel_write()

And powerpc seems to rely on "pte" locking taken by

  + apply_relocate_add()
    + patch_instruction()
      + patch_mem()
	+ __do_patch_mem_mm()
	  + get_locked_pte()

I see two possibilities:

  1. Either this change makes a false feeling that "text_mutex"
     sychronizes apply_relocate_add() on all architextures.

     This does not seems to be the case on, for example, s390
     and powerpc.

     => The code is misleading and could lead to troubles.


   2. Or it actually provides some sychronization on all
      architectures, for example, against kprobe code.

      In this case, it might actually fix an existing race.
      It should be described in the commit message
      and nominated for backporting to stable.


I am sorry if this has already been discussed. But I have been
in Cc only for v3 and v4. And there is no changelog in
the cover letter.

> +
> +	if (apply)
> +		ret = apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +	else
> +		clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +
> +	if (!early)
> +		mutex_unlock(&text_mutex);
> +	return ret;
>  }

Best Regards,
Petr

