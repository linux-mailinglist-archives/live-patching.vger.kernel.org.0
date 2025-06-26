Return-Path: <live-patching+bounces-1529-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C68AEAA98
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1692E3BE59C
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B1D225785;
	Thu, 26 Jun 2025 23:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ho8C3Pi0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1F22253EE;
	Thu, 26 Jun 2025 23:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750980452; cv=none; b=B1NJ96QoQWkSCesP88bjHy0VJtbq7Fsr9uxGSapMwS8ECzgKxUHXhs7hV0VM9xk4vifrX1rbkYByRRcRLesYTuZAeetcpZyNKAH5PHfYjmJdteMpzDR6seG6c43mqJuGNKFPIAhxcFPhnFME9szxc6EwiklHQttNDNZSQK3Bzts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750980452; c=relaxed/simple;
	bh=V9ZFFu06Gx4VRv5ACITTag+DK1If3ZV6TP8DupOmiEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uY66Hzkq6cf2XOUPvnFnDLLM7SNrk3kzPyb/J7WtMiIMuRRPm1UlJj4gJVKEZ+2uFa66GVQdit38+DqHJSNhTXIHFyxPUUsQESbOrYrxJzLxxa0bHmhuuKXfNB8LdQGPxdGLaokmv7glxPRxB0oNGnyJrvwrrb1nCTaMokj2vBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ho8C3Pi0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71324C4CEF2;
	Thu, 26 Jun 2025 23:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750980450;
	bh=V9ZFFu06Gx4VRv5ACITTag+DK1If3ZV6TP8DupOmiEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ho8C3Pi0O7kC1H8wV1QxFR0tOrczbsCZp8A0KOeSJBbQfwjkS7BhjkId5iYIb4PsM
	 g4Mk7cWhskKUxxadlb7qR2urk3bSG33wLoRJncPN5X4RIWMKqk6TTD+F7C3d285oHU
	 vgwdwElSXI58ypWIZRWS5kGotrZSKPgnfZCzwnm7x8tKktTS/9A2HYqWqRYh/ebAN/
	 zzUcLBWA9M3geCRxWLs9fI3zp/aVf3H1QMKxPd4ITXi5z3xI2MKHKF5Q5ym6bgotjE
	 +pb689FXMnoZIa2h6wIqnfebMZyIUUZsBXBCgi8NmxTTbIL68yo3vvZFFlLgGrrQBf
	 OiIlSSuyDMJ3A==
Date: Thu, 26 Jun 2025 16:27:27 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
Message-ID: <2pwptog6wdwbpz7jzu4ftiwu33aehmgrsh5oqou36jgfqlqrqk@bvezulebykbn>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <CADBMgpxP31YyRMXkHnCvjbb7D8OaUuGKbR9_66pRjGsBd57m8A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADBMgpxP31YyRMXkHnCvjbb7D8OaUuGKbR9_66pRjGsBd57m8A@mail.gmail.com>

On Wed, Jun 18, 2025 at 05:38:07PM -0500, Dylan Hatch wrote:
> On Fri, May 9, 2025 at 1:30 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > +
> > +# Make sure git re-stats the changed files
> > +git_refresh() {
> > +       local patch="$1"
> > +       local files=()
> > +
> > +       [[ ! -d "$SRC/.git" ]] && return
> 
> As a user of git worktrees, my $SRC/.git is a file containing a key:
> value pair "gitdir: <path>", causing this script to fail on a [[ ! -d
> "$SRC/.git" ]] check. Can this be handled, perhaps with a check if
> .git is a file?
> 
> It seems like the check is just to confirm the $SRC directory is still
> a git tree, in which case maybe adding a -f check would fix this:
> 
> [[ ! -d "$SRC/.git" ]] && [[ ! -f "$SRC/.git" ]] && return
> 
> Or if the actual git directory is needed for something, maybe it can
> be located ahead of time:
> 
> GITDIR="$SRC/.git"
> [[ -f $GITDIR ]] && GITDIR=$(sed -n
> 's/^gitdir[[:space:]]*:[[:space:]]*//p' $GITDIR)

I believe the subsequent "git update-index" operation should work on git
worktrees as well, so I changed that to use '-e':

	[[ ! -e "$SRC/.git" ]] && return

-- 
Josh

