Return-Path: <live-patching+bounces-1866-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A32C67892
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 06:27:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 0FDB02AF9D
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 05:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AC82D7DCC;
	Tue, 18 Nov 2025 05:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnejRp/Q"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035762D192B;
	Tue, 18 Nov 2025 05:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763443129; cv=none; b=U0pZ2CbNlNCXRXBGjy8+/iWmA3h5KakO9b2stBGvZPaFrCphfrkbbbznl0MDTZJ7e+vlMDMbgkYHWJR02gAAFKGkbIj8/ZJWuQ6fE7NOki3WRdUARwJTs/B5WNlta1gMyK+KCQZ3xIuSuqX5WHUIoDV0orkw3pc1xvjn0trJ1Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763443129; c=relaxed/simple;
	bh=pgxn/oJBHRGRKxafMMrLoLEGgcBl+d/M1jfcOI4RH7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oztRmIPGviBBrqB4BhHOFiK9xU+an5Y5nhPN1cc6pMntoMKEWTXiHPPLmwltjF4T0xdSPEZknkQ9SLa0c8C/BLzDDzMmulKYvv5FOWgxYrbdEl5JrxvFJPKx8bigwHCna/jdjBerIEcFbeSg2AcrGqIetgvKeumIQIue3k5iAmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnejRp/Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B794C19425;
	Tue, 18 Nov 2025 05:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763443126;
	bh=pgxn/oJBHRGRKxafMMrLoLEGgcBl+d/M1jfcOI4RH7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LnejRp/QGgpXgHhG652KAr+/fGCoxoSSyWbAKmUtVkis8OIVnsVcebzwbRlYP9ugf
	 kU/y2viPb/3PCy1L30qmVxwg4ETevqfh4CdkmjnV0l0o+122XlS0h9q0xi/46dgGhz
	 FqzcXJPUYIT5S9HIk9Dd80An3l9WsvlKM4U2WFRjXbi3J3RDsBpEfjtPXf7GhGnFFg
	 avRZoq2wf4TE9oXvcMj4f3m7sfUCbPMOk9rKWWzpFH/vfsjPauYikXGBngXSG2PFWM
	 R/v1IQDwnuODByqoDoD5sh26JPIL/Z/6ePsj/2x03zdSiiyUoSmjWrDL5re7hubFxO
	 Ez69mm3jeH2Rg==
Date: Mon, 17 Nov 2025 21:18:41 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Puranjay Mohan <puranjay12@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	Dylan Hatch <dylanbhatch@google.com>, Song Liu <song@kernel.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jiri Kosina <jikos@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
Message-ID: <bcxe5hhenqdodutgp7vd7b7aqn7emrlsezlu7stjjmfxgwc3gw@q3ggnid7ooyd>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
 <CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
 <CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com>
 <nzmtsafrx5vjitgfpducjaa7kq747a3sler2vvyvfbxecutn3v@7ffl2ycnaoo2>
 <20251117184223.3c03fe92@gandalf.local.home>
 <cxxj6lzs226ost6js5vslm52bxblknjwd6llmu24h3bk742zjh@7iwwi5bafysq>
 <CANk7y0hKH6vvWf3Lyc678uvF9YWStMzO-Sj8yb3sbS4=4dxC6Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANk7y0hKH6vvWf3Lyc678uvF9YWStMzO-Sj8yb3sbS4=4dxC6Q@mail.gmail.com>

On Tue, Nov 18, 2025 at 01:49:06AM +0100, Puranjay Mohan wrote:
> On Tue, Nov 18, 2025 at 1:10 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > On Mon, Nov 17, 2025 at 06:42:23PM -0500, Steven Rostedt wrote:
> > > On Mon, 17 Nov 2025 15:06:32 -0800
> > > Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > >
> > > > The ORC unwinder marks the unwind "unreliable" if it has to fall back to
> > > > frame pointers.
> > > >
> > > > But that's not a problem for livepatch because it only[*] unwinds
> > > > blocked/sleeping tasks, which shouldn't have BPF on their stack anyway.
> > > >
> > > > [*] with one exception: the task calling into livepatch
> > >
> > > It may be a problem with preempted tasks right? I believe with PREEMPT_LAZY
> > > (and definitely with PREEMPT_RT) BPF programs can be preempted.
> >
> > In that case, then yes, that stack would be marked unreliable and
> > livepatch would have to go try and patch the task later.
> >
> > If it were an isolated case, that would be fine, but if BPF were
> > consistently on the same task's stack, it could stall the completion of
> > the livepatch indefinitely.
> >
> > I haven't (yet?) heard of BPF-induced livepatch stalls happening in
> > reality, but maybe it's only a matter of time :-/
> >
> > To fix that, I suppose we would need some kind of dynamic ORC
> > registration interface.  Similar to what has been discussed with
> > sframe+JIT.
> 
> I work with the BPF JITs and would be interested in exploring this further,
> can you point me to this discussion if it happened on the list.

Sorry, nothing specific has been discussed that I'm aware of :-)

-- 
Josh

