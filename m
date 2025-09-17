Return-Path: <live-patching+bounces-1719-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DAEEB8250D
	for <lists+live-patching@lfdr.de>; Thu, 18 Sep 2025 01:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1AC062025D
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 23:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3903112B4;
	Wed, 17 Sep 2025 23:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgQtX1mH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F122265630;
	Wed, 17 Sep 2025 23:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758152504; cv=none; b=jeqrIpaOvY4oFfh82upeceI9jo6FAX1M3qlaE3PQD4C+n5ZSEPkDz5BrhaWfQZ7h/W1euVsf4z8cwQ9d/QzWb+nR7e0qbECq/XhhNQQsb2gWtPX4WsWYg0iKpvv8J4ovXDzLymvywFs84CXJimvAC0YoDz9j9E1JCD64PJIkqG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758152504; c=relaxed/simple;
	bh=gksuHgtQV130LdHluiSdfOyOFN0sEQGZ5ozfjzHEH/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o3ZoyrNeASwBRJ99GTwtkfmOqv4yb2GtYrd/JNHN91+wDxjYzpvs686ZqUnXE6X1jXmD7TC/S2mPBr6ra3u+u4LHJf2Z4PxvFRAH52WawGDcAPZ9c/mfSqSFcVraRogwAD4Fbe+x9wExF2v25qjl6KO5psop3yAk9nRwAz+jTmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgQtX1mH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EB2C4CEE7;
	Wed, 17 Sep 2025 23:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758152504;
	bh=gksuHgtQV130LdHluiSdfOyOFN0sEQGZ5ozfjzHEH/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kgQtX1mHxbWBpY5GSzq3w7RKE+uK5JfqSGL3GZXFGqbi6/MgQF2aY1H7TK0pFOMdK
	 p+oEwGu4w0bSRhsmWc2sXEqaYXtyunj57gdzSHVnc27ED2bukhTqtYjFAGKjXSAcfp
	 MMzv+2hH1ViP20I+Y5IIlTw3Gv7+Fphar5pcnM1n+wYAtGNHIWSCHcM2+ugUlvwyjS
	 auko+9otty8Cs0pYyQNx9HT0UydEPwRhKx8pXxksEcMKGUtcLWwD4PKLF9hlRGUs3m
	 2L1XBcP1WPBw0MY6EyBfFFMmMToAprEv9Iht6KBTvR5wArxW+vtk4YccUPVTSdL3lh
	 F5weYOOU9SehQ==
Date: Wed, 17 Sep 2025 16:41:41 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Subject: Re: [PATCH v2 6/6] unwind: arm64: Add reliable stacktrace with
 sframe unwinder.
Message-ID: <xo2ro446awhsd7i55shx6tlz6s2azuown4xk6zfm7ie4zz2nqc@244onpurkvy3>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <20250904223850.884188-7-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250904223850.884188-7-dylanbhatch@google.com>

On Thu, Sep 04, 2025 at 10:38:50PM +0000, Dylan Hatch wrote:
> +noinline notrace int arch_stack_walk_reliable(
> +				stack_trace_consume_fn consume_entry,
> +				void *cookie, struct task_struct *task)
> +{
> +	struct kunwind_reliable_consume_entry_data data = {
> +		.consume_entry = consume_entry,
> +		.cookie = cookie,
> +		.unreliable = false,
> +	};
> +
> +	kunwind_stack_walk(arch_kunwind_reliable_consume_entry, &data, task, NULL);
> +
> +	if (data.unreliable)
> +		return -EINVAL;

As far I can tell, the *only* error condition being checked is if it
(successfully) fell back to frame pointers.

What if there was some bad or missing sframe data?  Or some unexpected
condition on the stack?

Also, does the exception handling code have correct cfi/sframe metadata?

In order for it to be "reliable", we need to know the unwind reached the
end of the stack (e.g., the task pt_regs frame, from entry-from-user).

-- 
Josh

