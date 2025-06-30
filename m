Return-Path: <live-patching+bounces-1610-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC37BAED5D0
	for <lists+live-patching@lfdr.de>; Mon, 30 Jun 2025 09:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4524E3A860C
	for <lists+live-patching@lfdr.de>; Mon, 30 Jun 2025 07:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 105C9225403;
	Mon, 30 Jun 2025 07:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F0nPajaB"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C43C1FF7D7;
	Mon, 30 Jun 2025 07:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751268933; cv=none; b=QFzNlciIFjx6sErenlRlI9BbcHFCibGAL4yttsKqwHSVqEbpxJpKAU/AmL84ISiE3qm0awxEdHWqt2bsR8oEmZo+eQav9cdi3s5vXXKU05kKPUd9/vyEwAjaO+Nj3FZm5RABL+hL3Hj9C8L2fE/eOXIhee3nBj4fOS6W/RdNYi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751268933; c=relaxed/simple;
	bh=pBH6f9Yut4Y+IOdKkB8kToAtqO5eOMUX8Oytj6ItvVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IDF/kGOjk7YS8Z456zRISU+TQCKmB6qnP6PqHUjLw87Wz/hqM+BrJA4giAZtuJjEUU9nY4E6VLGh/lPh179jnnAg2zGFuOyNv+Q5m14mf9wbMZchfppKgeV35ASsBacAiEpDb0f42Wo/xs4KfjkOzPHF9XKRLlA+6aRhJEwApyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F0nPajaB; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9BGsYPOhKDHjSJL4ToFtlXBhQtz+EUS/bpoAUkX9Rbs=; b=F0nPajaBTPRrvPW4EHktXO9riX
	7hVl0GK/Uvq9X8MOQA/WPMQYtZevNQ0zzjAyn91ElX8i2zi2zFqRRm2n7fFJ1XA2o48jaOADXmWgG
	L7CkqpRtHj+OLoM14kjYYShIixYJ9u89pHr1+fFtRsfb/f0BYi+LtW7ZYdBZto5ZlGWyHdP/rcSYq
	nwJOsfFEgRy3BYtW3ZlmY3XOlcMzY2XOOAGDJ+z/UZ8lpuYjGT+i/i3GoMvq+H9ntVpw445L5OcFH
	78Yd3dSDWQrJv4mn3Ky4EhUW+1UnKbYNKP4xqUIOqdB6xpwPJmhxYqFZPh2xF3dcPlkYCkqALUzYP
	YRRviNkw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uW92x-00000003BlX-1XeU;
	Mon, 30 Jun 2025 07:35:23 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E5B3B300125; Mon, 30 Jun 2025 09:35:22 +0200 (CEST)
Date: Mon, 30 Jun 2025 09:35:22 +0200
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
Subject: Re: [PATCH v3 44/64] x86/jump_label: Define ELF section entry size
 for jump labels
Message-ID: <20250630073522.GF1613200@noisy.programming.kicks-ass.net>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <7217634a8158e56703dfe22199f1b9c08c501ae3.1750980517.git.jpoimboe@kernel.org>
 <20250627104818.GW1613200@noisy.programming.kicks-ass.net>
 <dhuk7aokj2hpqy3q65uqpv7bz4pwvg2zhngyfh44y7gmiujg4y@h6s354xixgf2>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dhuk7aokj2hpqy3q65uqpv7bz4pwvg2zhngyfh44y7gmiujg4y@h6s354xixgf2>

On Fri, Jun 27, 2025 at 09:55:30AM -0700, Josh Poimboeuf wrote:
> On Fri, Jun 27, 2025 at 12:48:18PM +0200, Peter Zijlstra wrote:
> > > +#define JUMP_TABLE_ENTRY(key, label)				\
> > > +	".pushsection __jump_table,  \"aM\", @progbits, "	\
> > > +	__stringify(JUMP_ENTRY_SIZE) "\n\t"			\
> > 
> > Argh, can you please not do this line-break. Yes it'll be long, but this
> > is most confusing.
> 
> Yeah, I'll go indent that like the extable one.
> 
> > > @@ -29,6 +30,9 @@ int main(void)
> > >  #else
> > >  	DEFINE(LRU_GEN_WIDTH, 0);
> > >  	DEFINE(__LRU_REFS_WIDTH, 0);
> > > +#endif
> > > +#if defined(CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE) && defined(CONFIG_JUMP_LABEL)
> > 
> > How is HAVE_ARCH_JUMP_LABEL_RELATIVE relevant here?
> 
> #ifdef CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE
> 
> struct jump_entry {
> 	s32 code;
> 	s32 target;
> 	long key;	// key may be far away from the core kernel under KASLR
> };

Well,... that's odd. I was sure there was a
!HAVE_ARCH_JUMP_LABEL_RELATIVE version somewhere... Oh well.

