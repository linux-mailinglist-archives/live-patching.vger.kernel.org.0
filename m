Return-Path: <live-patching+bounces-1729-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C4ACBBD4A8
	for <lists+live-patching@lfdr.de>; Mon, 06 Oct 2025 09:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E77674E0432
	for <lists+live-patching@lfdr.de>; Mon,  6 Oct 2025 07:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C9C25A2A4;
	Mon,  6 Oct 2025 07:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uh7FPxH4"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DFE24E4BD;
	Mon,  6 Oct 2025 07:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759737558; cv=none; b=Ou8jF8Dyjr4HyHxWw81TR6Fz/bxpWRBRcPccf3o3jJje9L3osGwWqIvKQ/UQxID6hCuU/9zH25zHpcQj6xVZ5Cys/NBCQyMRsmCRgYf2Z4fiHQkqoDeye1DRf1zT6VoFVmBYZvD/37N0BC03XeSIQs4wkhGoKp5f8b5W5q9Kknw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759737558; c=relaxed/simple;
	bh=xR9H+rVXuSmCG/aFcq1+uRILqW8RGM2Gf7+XvYtCszI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeOm9zCSF+a6BrwzVrYoPBaPGkm/dGXLlL+FiTu1AdO9XQfNOTa/JLo4IQXWdWT6J2oeCUJlWoOzrXmMFmcUpAP38bFkIJ5FNYwCYgA8nNKzHB14MWbA+R3b2ooAQFKE8D1jmTNj3qWR0hCuLQh0jWFJN//CftwX+h8GBbc0RvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uh7FPxH4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4493C4CEF5;
	Mon,  6 Oct 2025 07:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759737557;
	bh=xR9H+rVXuSmCG/aFcq1+uRILqW8RGM2Gf7+XvYtCszI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uh7FPxH4RneVNbXICvn+i3fnzPJBXfNXPclLpaWSWSUYFgAM0jRULI27hyu1GhE8B
	 7X6zKOe9S3wRUfQbjXZu4r8ihMaBthA9uu0Xmf+Sq27gzI3e/SQv5/u7jqcH9DWByR
	 u1Sw7v4DFIOayWEr8mZvRlsy1ddEW5DubHbi3TCz4jkFiNJkPZ7hG2/0i0WmMxP48A
	 vfva/6tK/IqPlfsGBInRmWXjY3FgA3UXuwdp5m5Bv4MwMg+dCx3gUYTUjqGpPtgrJq
	 WgM4xJFHyEx6Y7EoXPZYxKUt3JT5T+QyBc+abbGgStqdYd1s9o66TTBpxCFlQizTa0
	 NN9Ocjn78QDHg==
Date: Mon, 6 Oct 2025 13:22:38 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Hari Bathini <hbathini@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>, 
	Viktor Malik <vmalik@redhat.com>, live-patching@vger.kernel.org, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
	Jiri Kosina <jikos@kernel.org>, linux-trace-kernel@vger.kernel.org, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: Re: [PATCH] powerpc64/bpf: support direct_call on livepatch function
Message-ID: <amwerofvasp7ssmq3zlrjakqj5aygyrgplcqzweno4ef42tiav@uex2ildqjvx2>
References: <20251002192755.86441-1-hbathini@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002192755.86441-1-hbathini@linux.ibm.com>

On Fri, Oct 03, 2025 at 12:57:54AM +0530, Hari Bathini wrote:
> Today, livepatch takes precedence over direct_call. Instead, save the
> state and make direct_call before handling livepatch.

If we call into the BPF trampoline first and if we have 
BPF_TRAMP_F_CALL_ORIG set, does this result in the BPF trampoline 
calling the new copy of the live-patched function or the old one?

- Naveen


