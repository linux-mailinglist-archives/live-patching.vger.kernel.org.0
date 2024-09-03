Return-Path: <live-patching+bounces-566-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 229D4969640
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 09:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 552631C22E48
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 07:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3091D54D3;
	Tue,  3 Sep 2024 07:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M3mk1ojI"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0D21AB6C0;
	Tue,  3 Sep 2024 07:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725350202; cv=none; b=diILS32kllhsUdcB9NZaeNHDDwcvMSaadEnR37XKbD/r/WmCsXqBEoURq+r38l/dCdk4dWyJBQcWv/izdYYNwN2/4HFP0BkNCfHGRb1Jy3KQAuPaU0PktvfnvZuO/ED0Q7VGbItB4hQuBNFa42bNxobbBvNL/i6o0FlcNw6wXL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725350202; c=relaxed/simple;
	bh=3iqBpCGXD0+XoQjWD0N9kr9wPeUiZDyOWml2r1piz4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVSsbVd48YgurInhT2cnbbRCyNjQiIFGoMK6DXplMfgFRQ53uVcPz/vlHyIThvN4rLK0kwqfMQ9wOOWltbdGwDOSho4kUUo8FD1uttZm6sM98BmAz3e3TJUPdcYzGqE7JQl9k+ZYlbauoeQEhYK5hRsw3OuSpscwE2OQdP96fSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M3mk1ojI; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EJj1lsHhkDenjaw2zJUFO78CGxYRY5w+c/TRMqgr/ns=; b=M3mk1ojIlF0ZMZxUKKCBdUSxqy
	R5qJrJiLcgnV1EriaXulB3T7liZbQbEkL7URw/RedNsLC9zDpB7WhYWmx9J6QN6AUcUF5zCK6rjMU
	whNjbwPWcMxOkNmH+QvIZBuf4tOZusMuDSjRpNRTf2eFdZ9t8jv/ZKlp5SfcUgDNhcLXKZmv/BaTK
	tOc1ToNTXWDwzuztDGFMhNrQrojhE1ZvjQ4F9bZXjmysffCyV84nIlgWoPCa9yXbVmzyc7TOBxIsN
	417KAM2IEEkeAU0C4oo0xLzzQz4z4r9PQipOvrc9+F2r8B8GU1XFijILLRi/XT606/TiOiYLuerRZ
	MEPDK1sA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slOOy-0000000CHis-09M4;
	Tue, 03 Sep 2024 07:56:36 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E1E39300390; Tue,  3 Sep 2024 09:56:34 +0200 (CEST)
Date: Tue, 3 Sep 2024 09:56:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 05/31] x86/compiler: Tweak __UNIQUE_ID naming
Message-ID: <20240903075634.GL4723@noisy.programming.kicks-ass.net>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <d8d876dcd1d76c667a4449f4673104669480c08d.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8d876dcd1d76c667a4449f4673104669480c08d.1725334260.git.jpoimboe@kernel.org>

On Mon, Sep 02, 2024 at 08:59:48PM -0700, Josh Poimboeuf wrote:
> Add an underscore between the "name" and the counter so tooling can
> distinguish between the non-unique and unique portions of the symbol
> name.
> 
> This will come in handy for "objtool klp diff".
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  include/linux/compiler.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 8c252e073bd8..d3f100821d45 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -186,7 +186,11 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
>  	__asm__ ("" : "=r" (var) : "0" (var))
>  #endif
>  
> -#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
> +/* Format: __UNIQUE_ID_<name>_<__COUNTER__> */
> +#define __UNIQUE_ID(name)					\
> +	__PASTE(__UNIQUE_ID_,					\
> +	__PASTE(name,						\
> +	__PASTE(_, __COUNTER__)))

OK, that's just painful to read; how about so?

	__PASTE(__UNIQUE_ID_,					\
	        __PASTE(name,					\
		        __PASTE(_, __COUNTER)))

>  
>  /**
>   * data_race - mark an expression as containing intentional data races
> @@ -218,7 +222,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
>   */
>  #define ___ADDRESSABLE(sym, __attrs) \
>  	static void * __used __attrs \
> -	__UNIQUE_ID(__PASTE(__addressable_,sym)) = (void *)(uintptr_t)&sym;
> +	__UNIQUE_ID(__PASTE(addressable_, sym)) = (void *)(uintptr_t)&sym;

This change doesn't get mention ?

>  #define __ADDRESSABLE(sym) \
>  	___ADDRESSABLE(sym, __section(".discard.addressable"))
>  
> -- 
> 2.45.2
> 

