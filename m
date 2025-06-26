Return-Path: <live-patching+bounces-1527-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D912AEA9CE
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CB8C564ED2
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 22:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1489E26E707;
	Thu, 26 Jun 2025 22:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SvMg+MZ8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCBC20487E;
	Thu, 26 Jun 2025 22:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750977829; cv=none; b=RbKCcfMNxAfJ60JeBp33+amGhcZQ8Bv9ooFjP1QrNe/XCSbMy3KWxIf6PkaGXZmyCKYThBSt1OZqkX9SQPWdE9NQGPvOS7wizxuAaWA1CX/JXholrSbEQhgdsnMmC36/6UXUB8t994fuMYoT9azUFgEYUOwcO7cEIbMBxQeWrDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750977829; c=relaxed/simple;
	bh=KujrlBwbFUmz+hkWeoLZkVTYSDc5jUXDnX81zf8Cu4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQ886GXVxZOntri+H2r0wBPaBepFYSDR+gdschleGAWy6Xngh+VPXvfQsgbT6kkpO6b6IjH493ccBqwF0LRNwa4REkyabTtxbOP4lLfJmW0Ami1/iRdnApiJNnNTC7QZfHB7VEHSrSjjyyejECl8eXu/vycyFX1XPlHJQwrPVlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SvMg+MZ8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CFBC4CEEB;
	Thu, 26 Jun 2025 22:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750977828;
	bh=KujrlBwbFUmz+hkWeoLZkVTYSDc5jUXDnX81zf8Cu4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SvMg+MZ85HL4ZOmKeyLaBm4/1FbUvKqJpMECoJqnTDjFtkUdig25AvzF4JOMoJBY7
	 jqfKhsV1l5ONk8m9GV+l+JejQ2Pn/wd6faWVLiHeiTXdwNwQeiSlUGK6de2/7jTFMA
	 48ZMQgwumb5rixriPREOPAT7YS8ZEvJTj7JtHI//aNNJLumOQZXz+h3ZxqpfrQzM0M
	 dMt/PKti6b6iHMijt0ecdhWcpG9vBcM3YiNkgo9oGA3Esfu6BeHtZwLDPyT/k/PsZt
	 BtPeI5oenz7UGXGgvQ/VyMDigUwlkKEADmvtCLKQmyEP1bH1WcPE2QqbOxUn/mN4e5
	 widoxgrghCYQA==
Date: Thu, 26 Jun 2025 15:43:45 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 29/62] objtool: Mark prefix functions
Message-ID: <tqdgtgqfokasfqqzbn4by6oaphxtwzg75egnq4lj76xjr6eabj@7idrvpy72xux>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <c4233972de0b0f2e6c94d4a225c953748d7c446b.1746821544.git.jpoimboe@kernel.org>
 <20250526104355.GM24938@noisy.programming.kicks-ass.net>
 <e2hv6jkitxvbtaqj377dvpwtn5tyaoux53ofkkegxcn3fapbcx@kfqxactn4ogj>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e2hv6jkitxvbtaqj377dvpwtn5tyaoux53ofkkegxcn3fapbcx@kfqxactn4ogj>

On Wed, Jun 04, 2025 at 05:04:33PM -0700, Josh Poimboeuf wrote:
> On Mon, May 26, 2025 at 12:43:55PM +0200, Peter Zijlstra wrote:
> > > +++ b/tools/objtool/elf.c
> > > @@ -442,6 +442,11 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
> > >  	elf_hash_add(symbol, &sym->hash, sym->idx);
> > >  	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
> > >  
> > > +	if (is_func_sym(sym) && sym->len == 16 &&
> > 
> > Where did that 'sym->len == 16' thing come from? I mean, they are, but
> > the old code didn't assert that.
> > 
> > I would rather objtool issue a warn if not 16, but still consider these
> > as prefix.
> 
> Ok:

Turns out there are kCFI cases with prefixes != 16, so I omitted the
size check altogether.

-- 
Josh

