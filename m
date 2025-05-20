Return-Path: <live-patching+bounces-1443-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CEDCBABDCF4
	for <lists+live-patching@lfdr.de>; Tue, 20 May 2025 16:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A4A61BC07AB
	for <lists+live-patching@lfdr.de>; Tue, 20 May 2025 14:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612AC24A07F;
	Tue, 20 May 2025 14:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1S/SWLv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E6424A06E;
	Tue, 20 May 2025 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747751332; cv=none; b=f/p8fzwUeD9j54ckWbKuBF0SgaMrHnEN9DYGbPp2qFue+RO24ewXQ/jE95K013QYnRoiLFKjEBbmV4bnjEDvTsD62Qkxqn4BET9sayDvElGKyemXwwQgtpXyKueVHJBGw0RH4XX6R0rzjsBIK+TtZqpZw5QMHQx8YteZysRIZAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747751332; c=relaxed/simple;
	bh=RT+HPlhcuk/pySSVcjY3DaH4g16kjYMQ2/8qrwSmd8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qiY21OVx6zwaIEQjM490yROaCFZ/iPLao5AshqWIRmnO1VUnAJMFiv1EHhEADHxc7lSqsxdmMTFiLkwVVb/q5Jf7Bk3yCp5azsZaiVqyygsXHS8ZTj8RCgR1JeQnyfHAMFzUTsh+1/eRWFWF2icmsq7FZ1crJTNbB9JQAKbn0OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1S/SWLv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8C2C4CEE9;
	Tue, 20 May 2025 14:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747751331;
	bh=RT+HPlhcuk/pySSVcjY3DaH4g16kjYMQ2/8qrwSmd8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n1S/SWLvz3cIyclj3BPJe0OrNjBmWv1N8+sit7t6sVSXBnIbhqwpnwhHF8r9U0O8D
	 mrxG5z3euaL2pDtdTUYRVcd2ebCfATINAkd7UTSKcKl9m0d9mjgR/XEXMHaPAuQrEv
	 V5Yud/38PwijNXDaK9gpYC4GmYmKyAXDVJEVd2AJv0LQkc8w6gQUTqqOPa/JEez8c3
	 v7z+MTeN31ObDI/OpbqS9VsjfA2XKYRaar2wtpAVXFZKy8npxHR3T6nGTUiM9VviEc
	 ZXauznCkYWlEfJcPIu92q+6+bQ+j8oUTnl0LqhacdZoNF9VwFMxL/DQrzbVukyb8yl
	 Ne+53ipCE2e+Q==
Date: Tue, 20 May 2025 15:28:45 +0100
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Song Liu <song@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-toolchains@vger.kernel.org,
	live-patching@vger.kernel.org, indu.bhagat@oracle.com,
	puranjay@kernel.org, wnliu@google.com, irogers@google.com,
	joe.lawrence@redhat.com, jpoimboe@kernel.org, peterz@infradead.org,
	roman.gushchin@linux.dev, rostedt@goodmis.org, kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] arm64: Implement arch_stack_walk_reliable
Message-ID: <20250520142845.GA18846@willie-the-truck>
References: <20250320171559.3423224-1-song@kernel.org>
 <20250320171559.3423224-2-song@kernel.org>
 <aCs08i3u9C9MWy4M@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCs08i3u9C9MWy4M@J2N7QTR9R3>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, May 19, 2025 at 02:41:06PM +0100, Mark Rutland wrote:
> I've pushed a arm64/stacktrace-updates branch [1] with fixups for those
> as two separate commits atop this one. If that looks good to you I
> suggest we post that as a series and ask Will and Catalin to take that
> as-is.

Yes, please post those to the list for review.

Will

