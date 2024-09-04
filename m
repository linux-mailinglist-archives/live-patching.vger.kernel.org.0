Return-Path: <live-patching+bounces-595-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3274996C3A5
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 18:14:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3FCC288133
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 16:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DD31DFE0F;
	Wed,  4 Sep 2024 16:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+J4l/JQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1BE1DEFC2;
	Wed,  4 Sep 2024 16:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725466396; cv=none; b=uTmh/dWlns+EtECQkm6cxnpN3/3I9c/ByyN53loNd0M/Q7COyasM2N6apUmBwlSoS4shpW2UxbPehsTbDKuyjqBO2IkwTHURwk+TD6Rt7OmN2wnXc6lpf/nG+ri9t2NMXvI5zTFE6q9PkcBaGwJ2Lg5cPnw2ufPdJAnaL584ARU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725466396; c=relaxed/simple;
	bh=WBEX+jMwoCwFQZuNeQlEszBNu8t4Azg15u61+qAqC4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+EqyU0rKPZYfzLD2wnQTxp6dwBy9hXMlCvPI2Jj4ImSAc0tAX5oAFeeZwFaQvvtqjgmrIZ82OB8v7PXi18ivWQGolma2auLG5mMSugekk/CDStaD6XKwy6Oh4q6+I4kbjkR2JQxii9Dm3q9fWyuMb24pHAkyrS05994zUH7tNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+J4l/JQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39895C4CEC2;
	Wed,  4 Sep 2024 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725466395;
	bh=WBEX+jMwoCwFQZuNeQlEszBNu8t4Azg15u61+qAqC4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s+J4l/JQR6MPmivtWcuIFCy1tx7j4JijegWkyDM2yJT81aDRQLwR11PoqlD1qQxKd
	 MdprWvs/hVA4Um8jT1ARgunFv0+XvRtuuIyN0RP0jMEzuu/x3aBWXRVwh74Hh8CsQ+
	 eqWf9AojxbYx1B0PnY7Hzugj/MubYvWWbYxi3mU+wMEj+FRQ00ylySQN3Tqd24Msbx
	 x5rykcP1/ic1z0HzNc2nf5NojA10G6V7eUpweKLMKHNG/PQAheYCsoq7dSv1of4tBj
	 JsU8Li+DKYK36GXEErzTyiv6UPzOSl4sDtgZunEhvpRP2J4IaEmesvYIkVZ8Tuw8k0
	 1qJ49GdwVXzQw==
Date: Wed, 4 Sep 2024 09:13:13 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 28/31] x86/alternative: Create symbols for special section
 entries
Message-ID: <20240904161313.p537aq2vbmuli6bj@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
 <20240903082909.GP4723@noisy.programming.kicks-ass.net>
 <20240904042829.tkcpql65cxgzvhpx@treble>
 <20240904080842.GE4723@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240904080842.GE4723@noisy.programming.kicks-ass.net>

On Wed, Sep 04, 2024 at 10:08:42AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 03, 2024 at 09:28:29PM -0700, Josh Poimboeuf wrote:
> > Take a more generic approach: for the "array of structs" style sections,
> > annotate each struct entry with a symbol containing the entry.  This
> > makes it easy for tooling to parse the data and avoids the fragility of
> > hardcoding section details.
> > 
> > (For the "array of pointers" style sections, no symbol is needed, as the
> > format is already self-evident.)
> 
> (so someone went and touched a ton of the alternative code recently,
> this is going to need a rebase)
> 
> This generates a metric ton of symbols and I'm not seeing you touch
> kallsyms.c, do we want to explicitly drop these from a --all-symbols
> build? I don't think it makes sense to have them in the final image,
> right?

Yes, good point.

-- 
Josh

