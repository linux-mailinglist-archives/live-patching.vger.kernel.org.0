Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EF61B4517
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2020 14:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgDVM22 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Apr 2020 08:28:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:40608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgDVM22 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Apr 2020 08:28:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6DC6AAEBF;
        Wed, 22 Apr 2020 12:28:26 +0000 (UTC)
Date:   Wed, 22 Apr 2020 14:28:26 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com
Subject: Re: [PATCH v2 6/9] s390/module: Use s390_kernel_write() for late
 relocations
In-Reply-To: <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
Message-ID: <alpine.LSU.2.21.2004221411140.28581@pobox.suse.cz>
References: <cover.1587131959.git.jpoimboe@redhat.com> <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> +int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
> +		       unsigned int symindex, unsigned int relsec,
> +		       struct module *me)
> +{
> +	int ret;
> +	bool early = me->state == MODULE_STATE_UNFORMED;
> +	void *(*write)(void *, const void *, size_t) = memcpy;
> +
> +	if (!early) {
> +		write = s390_kernel_write;
> +		mutex_lock(&text_mutex);
> +	}
> +
> +	ret = __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
> +				   write);
> +
> +	if (!early)
> +		mutex_unlock(&text_mutex);
> +
> +	return ret;
> +}

It means that you can take text_mutex the second time here because it 
is still taken in klp_init_object_loaded(). It is removed later in the 
series though. The same applies for x86 patch.

Also, s390_kernel_write() grabs s390_kernel_write_lock spinlock before 
writing anything, so maybe text_mutex is not really needed as long as 
s390_kernel_write is called everywhere for text patching.

Miroslav
