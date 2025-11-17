Return-Path: <live-patching+bounces-1861-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 35558C66873
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 00:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 52EBE4E2FB5
	for <lists+live-patching@lfdr.de>; Mon, 17 Nov 2025 23:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC146248896;
	Mon, 17 Nov 2025 23:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FAftbyEx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807DD184540;
	Mon, 17 Nov 2025 23:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763420797; cv=none; b=Yk+BZz05O/rrXrgc/XEZTMPyGSen80Xh2AtrElC1fwVoONhWiU34DEBEMUlgHW5XWSDjIDDmc7oPxB8UlUJk2e6BOgthj3UqMAEKFiq6OEI7DnxTc0ejf/xF2HIqpjZnKOi8JBjie8tMB5WLDvv7fcM5M1cg71vNqN4geWpVE6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763420797; c=relaxed/simple;
	bh=9tB/S0iGw6x/PSpO9qPz/mZQjc1eBaQP1GWw54gyuNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EWPwVw4xT3opG6+xKnm3TMpa7fep3ivfUGLFkDqG/eSP6AzFVUeP6hyEIdrwQilkt3wTSnwRiCsgQxjgVbODz3slqTI8JIuJVTd5gU5q9pbMDQ8Rkf1u3sh6UHG58HNIfiPgpZpGJ3zT+U7KLpsPbvQVvZ/V+h47UnZ0TJyEcw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FAftbyEx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C59C2BC87;
	Mon, 17 Nov 2025 23:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763420796;
	bh=9tB/S0iGw6x/PSpO9qPz/mZQjc1eBaQP1GWw54gyuNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FAftbyExzDx+orTZGtk5ens60oGqH07nAwWZJO9pOSI79YzpNRAhhf8Yo638YOoZu
	 RlVLug9Z9I4XyQDX1H9o+y8vIUDpmEZRhYUZliju2GwhZjZ2AJFYXjYZ1d9LIcCpio
	 NgEBlLORVW5VarLDfMUgeOu4Xo9wEEdM6hUfKZee5PqoGKt6uPSQlR4q4W+TAk2nZf
	 Qg5HZ7Fz2FFa7c/OxaOGnrcA30ruJNsYmQt+6mrCOpdm69t+wPQ3LsPrdWu7sOBXDP
	 ow4AkYnPT4kVWuzUZKdAHIhwOQxexlO4WcRqNPZP7x2NSvuWHes/sRfJc5h5UEvdgg
	 qwj5Nl2rlKfFA==
Date: Mon, 17 Nov 2025 15:06:32 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Puranjay Mohan <puranjay12@gmail.com>, Song Liu <song@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jiri Kosina <jikos@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
Message-ID: <nzmtsafrx5vjitgfpducjaa7kq747a3sler2vvyvfbxecutn3v@7ffl2ycnaoo2>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
 <CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
 <CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com>

On Fri, Nov 14, 2025 at 10:50:16PM -0800, Dylan Hatch wrote:
> On Mon, Sep 29, 2025 at 12:55 PM Puranjay Mohan <puranjay12@gmail.com> wrote:
> >
> > I will try to debug this more but am just curious about BPF's
> > interactions with sframe.
> > The sframe data for bpf programs doesn't exist, so we would need to
> > add that support
> > and that wouldn't be trivial, given the BPF programs are JITed.
> >
> > Thanks,
> > Puranjay
> 
> From what I can tell, the ORC unwinder in x86 falls back to using
> frame pointers in cases of generated code, like BPF. Would matching
> this behavior in the sframe unwinder be a reasonable approach, at
> least for the purposes of enabling reliable unwind for livepatch?

The ORC unwinder marks the unwind "unreliable" if it has to fall back to
frame pointers.

But that's not a problem for livepatch because it only[*] unwinds
blocked/sleeping tasks, which shouldn't have BPF on their stack anyway.

[*] with one exception: the task calling into livepatch

-- 
Josh

