Return-Path: <live-patching+bounces-1597-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD40AEB4EE
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 12:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58FC01C21C95
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 10:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E642BDC1D;
	Fri, 27 Jun 2025 10:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OcdG1Gho"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031D0298996;
	Fri, 27 Jun 2025 10:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751020186; cv=none; b=IBDgOc2dZoO3Z5nkO28vS3OuBBJPm0uEPbu0QV+L013ZMQffX6FsdiwIsCDMCsq+nIvL4aqSk7pTZ8rsKvR34HS4UzsuMkjtatplOQ+0ypCDXwys+1SGnexXA6UGYap2yPH6yJkV9kqd55q39NxFAw2ANQDyxrfL+Fa6JeFzAHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751020186; c=relaxed/simple;
	bh=fxxnsqYVj44bqdTtrWf0Pa18mSdf5qVyV6pvT9Lt990=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ecSRIrWRBG4QwOCCcJpAYOjhmBL5lJqKyqzlv9Hq4NYcQ/ruKkorcOLfUk8NmnhVQh8vTMz5ET+nRRcWANQOH3rnFch2qJuXC+CUqp7AHcXA1PBafRA7j/m3huvwr/jnLmpMPcThHWzoXxQmhhXxNElZ1/KIyLAKq/L7xOPLFsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OcdG1Gho; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NTo9B/0JaMaJmJH7vjJ70ZwqNHFhkhkJqmR2lsO5Mc8=; b=OcdG1GhoheuSXY8Y8B7osPhahy
	fX0QPohM57jQrYhywOaMTFT7l6XLyxy7tHXUoey5gSGe5XhBNJEffb8Izg+cEv/O8rJBtqOxMWoPX
	rYZMIoFbVGlFfRFtI4Js0tW2pMUOjzTMM0eiPGMN8B4RM/Xv+Av4CKGFKpsm8DjhbFJz9WXos21M3
	ofHnlwYtwtlJtmMzcmL7XaGHO9kvPOjvgq9uIIg/o7Yh67khTQ1yc19cskBONkJPj4tCVyB2DVBs5
	WoJsNgD+ZZfYQHS/bJXTTXtZVeNlJ/nBwGJpAMtPFDWMktaRlt08dzdfoozgDxP9+4Kww4hZl3zjF
	xPSNyrZg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uV6Kp-0000000Dpdd-3u62;
	Fri, 27 Jun 2025 10:29:32 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B43A6300222; Fri, 27 Jun 2025 12:29:30 +0200 (CEST)
Date: Fri, 27 Jun 2025 12:29:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: Re: [PATCH v3 26/64] objtool: Add section/symbol type helpers
Message-ID: <20250627102930.GU1613200@noisy.programming.kicks-ass.net>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <c897dc0a55a84f9992b8c766214ff38b0f597583.1750980517.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c897dc0a55a84f9992b8c766214ff38b0f597583.1750980517.git.jpoimboe@kernel.org>

On Thu, Jun 26, 2025 at 04:55:13PM -0700, Josh Poimboeuf wrote:
> @@ -177,11 +178,71 @@ static inline unsigned int elf_text_rela_type(struct elf *elf)
>  	return elf_addr_size(elf) == 4 ? R_TEXT32 : R_TEXT64;
>  }
>  
> +static inline bool sym_has_sec(struct symbol *sym)
> +{
> +	return sym->sec->idx;
> +}
> +
> +static inline bool is_null_sym(struct symbol *sym)
> +{
> +	return !sym->idx;
> +}
> +
> +static inline bool is_sec_sym(struct symbol *sym)
> +{
> +	return sym->type == STT_SECTION;
> +}
> +
> +static inline bool is_object_sym(struct symbol *sym)
> +{
> +	return sym->type == STT_OBJECT;
> +}
> +
> +static inline bool is_func_sym(struct symbol *sym)
> +{
> +	return sym->type == STT_FUNC;
> +}
> +
> +static inline bool is_file_sym(struct symbol *sym)
> +{
> +	return sym->type == STT_FILE;
> +}
> +
> +static inline bool is_notype_sym(struct symbol *sym)
> +{
> +	return sym->type == STT_NOTYPE;
> +}
> +
> +static inline bool is_global_sym(struct symbol *sym)
> +{
> +	return sym->bind == STB_GLOBAL;
> +}
> +
> +static inline bool is_weak_sym(struct symbol *sym)
> +{
> +	return sym->bind == STB_WEAK;
> +}
> +
> +static inline bool is_local_sym(struct symbol *sym)
> +{
> +	return sym->bind == STB_LOCAL;
> +}
> +
>  static inline bool is_reloc_sec(struct section *sec)
>  {
>  	return sec->sh.sh_type == SHT_RELA || sec->sh.sh_type == SHT_REL;
>  }
>  
> +static inline bool is_string_sec(struct section *sec)
> +{
> +	return sec->sh.sh_flags & SHF_STRINGS;
> +}
> +
> +static inline bool is_text_sec(struct section *sec)
> +{
> +	return sec->sh.sh_flags & SHF_EXECINSTR;
> +}
> +
>  static inline bool sec_changed(struct section *sec)
>  {
>  	return sec->_changed;
> @@ -222,6 +283,11 @@ static inline bool is_32bit_reloc(struct reloc *reloc)
>  	return reloc->sec->sh.sh_entsize < 16;
>  }
>  
> +static inline unsigned long sec_size(struct section *sec)
> +{
> +	return sec->sh.sh_size;
> +}
> +


Naming seems inconsistent, there are:

  sym_has_sec(), sec_changed() and sec_size()

which have the object first, but then most new ones are:

  is_foo_sym() and is_foo_sec()

which have the object last.


Can we make this consistent and do something like:

  s/is_\([^_]*\)_\(sym\|sec\)/\2_is_\1/

?

