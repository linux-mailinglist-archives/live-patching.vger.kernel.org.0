Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7021ADFE8
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2020 16:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDQO3u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Apr 2020 10:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDQO3u (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Apr 2020 10:29:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953C4C061A0C;
        Fri, 17 Apr 2020 07:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rhvxWH9vx73LZxxbSLZjrpt6xiGRw+gmZ6cOdnw55xQ=; b=BbU0gDPuafoS2nVanEcj/vqeMM
        OZtn9r+O/5Vg5H5hwI+87H0npqjd7CFoR/MyBnlj+Y0nHXekfBnEauUIad6MZXPlD3P0HDroaY25n
        xZZ5XqkYjZMey9qa9p63W74y9wlbhGJ2N9NvodNp+bSDkFsfzv3vMnd2ji3sC2/m8UyB3i4SpveX/
        doh2Qzvk7XH2/Ol8MyI25RY5lXbCWCJx46vndeUUWEnEFZ0ku7fdeq4Z7vQvudiNdEP5fxnA8rVab
        ZPkuSUpoO5qsdz4tlCw8tlXVHoTlTKkf0R3HZd9GJOa22uTSYUFj9mmcg6DbAuIs6e4AC7wif5coH
        6kdqGLhw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPS02-0005mv-PM; Fri, 17 Apr 2020 14:29:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7EFBD3006E0;
        Fri, 17 Apr 2020 16:29:44 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6680A2B121814; Fri, 17 Apr 2020 16:29:44 +0200 (CEST)
Date:   Fri, 17 Apr 2020 16:29:44 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org
Subject: Re: [PATCH v2 7/9] x86/module: Use text_poke() for late relocations
Message-ID: <20200417142944.GF20730@hirez.programming.kicks-ass.net>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <572b12b6adcdab29c54cfd41ca8b4672abad628c.1587131959.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <572b12b6adcdab29c54cfd41ca8b4672abad628c.1587131959.git.jpoimboe@redhat.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 17, 2020 at 09:04:32AM -0500, Josh Poimboeuf wrote:
> +int apply_relocate_add(Elf64_Shdr *sechdrs,
> +		   const char *strtab,
> +		   unsigned int symindex,
> +		   unsigned int relsec,
> +		   struct module *me)
> +{
> +	int ret;
> +	bool early = me->state == MODULE_STATE_UNFORMED;
> +	void *(*write)(void *, const void *, size_t) = memcpy;
> +
> +	if (!early) {
> +		write = text_poke;
> +		mutex_lock(&text_mutex);
> +	}
> +
> +	ret = __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
> +				   write);
> +
> +	if (!early) {
> +		mutex_unlock(&text_mutex);
> +		text_poke_sync();

I'm thinking text_poke_sync() wants to be inside text_mutex. Although
given that nothing should be running that text, it really doesn't
matter.

> +	}
> +
> +	return ret;
> +}
> +
>  #endif
>  
>  int module_finalize(const Elf_Ehdr *hdr,
> -- 
> 2.21.1
> 
