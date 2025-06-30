Return-Path: <live-patching+bounces-1608-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C80B2AED59D
	for <lists+live-patching@lfdr.de>; Mon, 30 Jun 2025 09:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C51D23A2968
	for <lists+live-patching@lfdr.de>; Mon, 30 Jun 2025 07:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F6921D3C0;
	Mon, 30 Jun 2025 07:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c93XlBE3"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE60821D599;
	Mon, 30 Jun 2025 07:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751268607; cv=none; b=HfaQ3xRLi9W06L7c9aHTCxDgm8hthKjDqiCubvEUho0STigCFZJEO4vMDqohMByYhg2k3tsxvtJyysHGKegJWn/yxoDQOmQXsySGWLEHphBWl7RvseZ5qjxHwfwpwqwNQK3+UKYCci89YxiPwYYLhTv4VtY/lFNxTs54zC9oYZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751268607; c=relaxed/simple;
	bh=4icsyX1fyuJ4g4NGEg3pYYUUJOo9oPnmjKEd0Ktd9Tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUqj1v/pflpAkl94+hQ4R9jjxTiD6JjLwCP8K5fn/Fns6o7jor5gsnlAdOBpZbr5DYs9UC4t01sNukxwb4AjMl7jQ4dws35Tpw2AqIeVkVWtAb5vlsQnC+OmhFSznBBkLaim8zVSv/EePD8tgf+iEqbqHG9dfDEHYwRdw17oMVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c93XlBE3; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eClNPU+xMhIHfdyfGkZDmnpHBZwwzECYZaiFVFjlBxA=; b=c93XlBE34i31RtnXjJBAaMaoeH
	HjnKzwQLwlCmjKEk36gVPwdg2fMwEBZsLWARHj2JOXAFRQwJQV6PzQp6Y2XNiWaCl3YgvuG+5S9tl
	7oXpvsKIUTU+7KRE7bA5cgldjxaDoiJZVSKqpITQrtowszfb9+eXVMHZOs2CoZcZ+gghkkF6PDrfA
	exGuintC1HqzJ1TlttgQ/BpednJQ12v1fcNQeHyf3z7rwNz5wtWT0fO8o2HG7NGNSNSJThMgbToi0
	0jouOIALMqpnn9THiee2/33RgseyGRMJcTmS1ZSzLfnFj5pPI3pT/2vZeSJ6K6BTc4+0hAft3oyi/
	MWCnQVig==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uW8xQ-00000003B6a-1EBp;
	Mon, 30 Jun 2025 07:29:40 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 98418300125; Mon, 30 Jun 2025 09:29:38 +0200 (CEST)
Date: Mon, 30 Jun 2025 09:29:38 +0200
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
Message-ID: <20250630072938.GD1613200@noisy.programming.kicks-ass.net>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <c897dc0a55a84f9992b8c766214ff38b0f597583.1750980517.git.jpoimboe@kernel.org>
 <20250627102930.GU1613200@noisy.programming.kicks-ass.net>
 <arotzpll7djck5kivv3d4bz2jpkitpejkppaaevoqk5hqddr57@aunxxyjwnrxz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arotzpll7djck5kivv3d4bz2jpkitpejkppaaevoqk5hqddr57@aunxxyjwnrxz>

On Fri, Jun 27, 2025 at 09:36:08AM -0700, Josh Poimboeuf wrote:
> On Fri, Jun 27, 2025 at 12:29:30PM +0200, Peter Zijlstra wrote:
> > Naming seems inconsistent, there are:
> >
> >   sym_has_sec(), sec_changed() and sec_size()
> >
> > which have the object first, but then most new ones are:
> > 
> >   is_foo_sym() and is_foo_sec()
> > 
> > which have the object last.
> 
> For the "is_()" variants, I read them as:
> 
>   "is a(n) <adjective> <noun>"
> 
> e.g.:
> 
>   is_undef_sym(): "is an UNDEF symbol"
>   is_file_sym():  "is a FILE symbol"
>   is_string_sec() "is a STRING section"
> 
> Nerding out on English for a second, many of those adjectives can be
> read as noun adjuncts, e.g. "chicken soup", where a noun functions as an
> adjective.
> 
> If we changed those to:
> 
>   "is <noun> <adjective>?"
> 
> or
> 
>   "is <noun> a <noun>?"
> 
> then it doesn't always read correctly:
> 
>   is_sym_file():   "is symbol a file?"
>   is_sec_string(): "is section a string?"

English aside; things like sym_*() create a clear namespace, and
sym_is_file() can be easily read as sym::is_file().



