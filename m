Return-Path: <live-patching+bounces-1614-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5191BAF0350
	for <lists+live-patching@lfdr.de>; Tue,  1 Jul 2025 21:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B5894E14D9
	for <lists+live-patching@lfdr.de>; Tue,  1 Jul 2025 19:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC2728136B;
	Tue,  1 Jul 2025 19:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p3wbpulq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1549F281353;
	Tue,  1 Jul 2025 19:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751396711; cv=none; b=l1xotMUdicZOu8fDPNajCJfs2ablQDOJbY+P/n74VjBH7NFnsOemSipn0kjZWnfHV2FYYvBqV3H4zBnQcqFTOV0ET63R4h7QxiqmAmxgDOhtTR5ON1DqIllHx+3d3UDiDMo3rqaL8OnGTNFye499h7oB8Dqlft/x+PYeYxWrMzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751396711; c=relaxed/simple;
	bh=Xpp2ylKWJ2IpyN29Q2uPRKPpwtPocLefmj6k9MIFt+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JF9coh7Rjj+mZFJmhXVP64nX4P7pin8xIgS+UaMlpvH/nRpAJI2T4WP+1n3V/oiTvbRvE593WdGxtTXbuFiTWWlZAQaua4uEqeS0WG+sKDV9Cdur5GQQW8Bi8CvayljkY6NDROozln4RI06rHZaWxLLVIxA0bzs3jLzM02AaIaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p3wbpulq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E96C4CEEE;
	Tue,  1 Jul 2025 19:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751396710;
	bh=Xpp2ylKWJ2IpyN29Q2uPRKPpwtPocLefmj6k9MIFt+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p3wbpulqW2o8WeLSvIBgTku+NadT4ZR8wZZmX6mpQA9pCBzA1peJj2BVj6nDVllvr
	 PeL8c3zo/fGHfyV7j2/QNfMlw82jidiSkiNwxX55U30sedRpaTJj9ObB4V21KITGBG
	 2FI+zk1evndwdvvGPLOzBupuC+pDHiwJFZMewyPGWfKJZ9XEO/Dip6Q78lHxRBfzzZ
	 9bYFhYPI4QSHcuLECGrxiS5AcpbrgG2WR8P4BpoEV6kp8p3anysJ4v2ByThJnAUjCe
	 XKJDfPbTHTYn1k88KcBMIvGkfyCbPy1YU/bMJNzwoGYMNTyE1TLlpQIMqF7CJD1ZDG
	 joQz4bwykBu+A==
Date: Tue, 1 Jul 2025 12:05:07 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>
Subject: Re: [PATCH v3 26/64] objtool: Add section/symbol type helpers
Message-ID: <tri3qd6zs4i56zip6zicjt3ode5mufao65ecog6hgqquga7cgi@l4hqhgmdjn4o>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <c897dc0a55a84f9992b8c766214ff38b0f597583.1750980517.git.jpoimboe@kernel.org>
 <20250627102930.GU1613200@noisy.programming.kicks-ass.net>
 <arotzpll7djck5kivv3d4bz2jpkitpejkppaaevoqk5hqddr57@aunxxyjwnrxz>
 <20250630072938.GD1613200@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250630072938.GD1613200@noisy.programming.kicks-ass.net>

On Mon, Jun 30, 2025 at 09:29:38AM +0200, Peter Zijlstra wrote:
> On Fri, Jun 27, 2025 at 09:36:08AM -0700, Josh Poimboeuf wrote:
> > On Fri, Jun 27, 2025 at 12:29:30PM +0200, Peter Zijlstra wrote:
> > > Naming seems inconsistent, there are:
> > >
> > >   sym_has_sec(), sec_changed() and sec_size()
> > >
> > > which have the object first, but then most new ones are:
> > > 
> > >   is_foo_sym() and is_foo_sec()
> > > 
> > > which have the object last.
> > 
> > For the "is_()" variants, I read them as:
> > 
> >   "is a(n) <adjective> <noun>"
> > 
> > e.g.:
> > 
> >   is_undef_sym(): "is an UNDEF symbol"
> >   is_file_sym():  "is a FILE symbol"
> >   is_string_sec() "is a STRING section"
> > 
> > Nerding out on English for a second, many of those adjectives can be
> > read as noun adjuncts, e.g. "chicken soup", where a noun functions as an
> > adjective.
> > 
> > If we changed those to:
> > 
> >   "is <noun> <adjective>?"
> > 
> > or
> > 
> >   "is <noun> a <noun>?"
> > 
> > then it doesn't always read correctly:
> > 
> >   is_sym_file():   "is symbol a file?"
> >   is_sec_string(): "is section a string?"
> 
> English aside; things like sym_*() create a clear namespace, and
> sym_is_file() can be easily read as sym::is_file().

A namespace isn't necessarily a good thing if it hurts readability.  A
file symbol is not a file.  A string section is not a string.  A rela
section is not a relocation.

It makes the code less readable because the natural English reading
("section is a string") doesn't make logical sense, so it takes longer
for the brain to parse.

-- 
Josh

