Return-Path: <live-patching+bounces-593-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2FB896C353
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 18:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 214FE1C2441F
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 16:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32BEB1DC73E;
	Wed,  4 Sep 2024 16:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYDTm/po"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5981DC052;
	Wed,  4 Sep 2024 16:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725465796; cv=none; b=UDIDKUHABzFZjU8Up8Ta3YRXtuVMYqhfssm7JHbtlU0uK5f4AnMa0aySj3asvuPbR2QG1ToQC6/3Ser7ww2dY50nvMNBwMyu93CQhJ9LL6ooR0CpOnF34ETIdaa0QlG1FBHAx7F7m+x5bPjgfC+m8K94QfKkxIAn9qXonqJ7o5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725465796; c=relaxed/simple;
	bh=ZSUcV14VBBXEec2JVwaDUWt4FsS1NxyoxqwsoTrSHf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJ+6rIDBbIycZ56Nq6ChTQh7MHGvTMpg3lqADlMcQlT823OZXIvwy8PGGGtjc55u9rglRQxydmMvxEQBjTQYgycs+1hZ6NDZKy8SNNI4ReS2h44jCN7cTXkcpT/rijTSAV45eTyQlysqqnghUXJjuGJFFCRKCy+dANwSn4KdLcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYDTm/po; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F964C4CEC2;
	Wed,  4 Sep 2024 16:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725465795;
	bh=ZSUcV14VBBXEec2JVwaDUWt4FsS1NxyoxqwsoTrSHf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nYDTm/pofgqG4onPxKoPfpI9Q/TI6qEqT9TcJCd4Vh3za1SkpVeSmJYjGGJ1axD6y
	 OSiNmEVHcN6yA1BnqUQN91gLGqQg8AfLGyRMUZLQj3aFZX84zIcwVHbqbHsAc0OQ5O
	 vGb5sExqEqtZ6lFrTL79TOT76HBcdXElb+WmqEqMBP7bvX5WSd0zZ2vCDnvqKPO09T
	 ojE6lz7XyBer6lb2x4qO0DWuYk/A81Wj/+HB/6mY1LA3UC//FThGbHLZR6/4UwoKV9
	 OV85ht/EPqVjsnnEUxd0d/zgODLhzcsJNRlUXpeMzN+PqcJ/TphRBYY+y60HsQl3DP
	 Hc52WAYwO0hFw==
Date: Wed, 4 Sep 2024 09:03:13 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 27/31] objtool: Fix weak symbol detection
Message-ID: <20240904160313.wvtutfkhrrlzc3qy@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <bcedaf8559e7e276e4d9ba511dab038ed70ebd6c.1725334260.git.jpoimboe@kernel.org>
 <20240903082645.GO4723@noisy.programming.kicks-ass.net>
 <20240904035513.cnbkivqibdklzpw2@treble>
 <20240904074254.GB4723@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240904074254.GB4723@noisy.programming.kicks-ass.net>

On Wed, Sep 04, 2024 at 09:42:54AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 03, 2024 at 08:55:13PM -0700, Josh Poimboeuf wrote:
> > On Tue, Sep 03, 2024 at 10:26:45AM +0200, Peter Zijlstra wrote:
> > > On Mon, Sep 02, 2024 at 09:00:10PM -0700, Josh Poimboeuf wrote:
> > > > @@ -433,9 +433,13 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
> > > >  	/*
> > > >  	 * Don't store empty STT_NOTYPE symbols in the rbtree.  They
> > > >  	 * can exist within a function, confusing the sorting.
> > > > +	 *
> > > > +	 * TODO: is this still true?
> > > 
> > > a2e38dffcd93 ("objtool: Don't add empty symbols to the rbtree")
> > > 
> > > I don't think that changed.
> > 
> > But see two patches back where I fixed a bug in the insertion of
> > zero-length symbols.
> > 
> > I was thinking that might actually be the root cause of the above
> > commit.
> 
> Aah, yeah, might be. If we can reproduce the original problem, it should
> be verifiable.

Indeed, I'll investigate.

-- 
Josh

