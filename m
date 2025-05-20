Return-Path: <live-patching+bounces-1444-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 883CCABE16B
	for <lists+live-patching@lfdr.de>; Tue, 20 May 2025 18:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 033AA7A7005
	for <lists+live-patching@lfdr.de>; Tue, 20 May 2025 16:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C1ED277006;
	Tue, 20 May 2025 16:59:45 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6EDC257AFB;
	Tue, 20 May 2025 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747760384; cv=none; b=VgWSXPKZ/6ac6ZAQs1uoiPcMvXP0UpqFIlYBX+PgCqk0j+CHCwbjgAbz0IXbk403XZFUuijMfFKqT/6qC0oKt7L6BCBN9LqFtNgAuO33cYxymJQd0fBchpED6EGbjww4Xj2YVJlvraJznTk1/ufLJSY2ZvpM/yjHS91pIyYowvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747760384; c=relaxed/simple;
	bh=zrLVYfoIkes3LrPYLk3Pw0KFTE0IuKNEFcraBOZjca8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=el6mWhz8iEkcLGhu2QhwPtHjT77Rr4MTzBm1ctIJnPZVU0ZJ9qivt5g4Dag29CBuD8rylAvbyAxBhAApj5XtYyQFcHy9M5XpmUDNb1aHyBdcFFCt95HwQNh44KqU3JnLn+0AUHVn55VRhGVxR/qcoobwEAI1HyVOczALWVd0q7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AE981516;
	Tue, 20 May 2025 09:59:28 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC1F23F5A1;
	Tue, 20 May 2025 09:59:39 -0700 (PDT)
Date: Tue, 20 May 2025 17:59:32 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Song Liu <song@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-toolchains@vger.kernel.org,
	live-patching@vger.kernel.org, indu.bhagat@oracle.com,
	puranjay@kernel.org, wnliu@google.com, irogers@google.com,
	joe.lawrence@redhat.com, jpoimboe@kernel.org, peterz@infradead.org,
	roman.gushchin@linux.dev, rostedt@goodmis.org, kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] arm64: Implement arch_stack_walk_reliable
Message-ID: <aCy09N8TwP1wEN-X@J2N7QTR9R3>
References: <20250320171559.3423224-1-song@kernel.org>
 <20250320171559.3423224-2-song@kernel.org>
 <aCs08i3u9C9MWy4M@J2N7QTR9R3>
 <20250520142845.GA18846@willie-the-truck>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520142845.GA18846@willie-the-truck>

On Tue, May 20, 2025 at 03:28:45PM +0100, Will Deacon wrote:
> On Mon, May 19, 2025 at 02:41:06PM +0100, Mark Rutland wrote:
> > I've pushed a arm64/stacktrace-updates branch [1] with fixups for those
> > as two separate commits atop this one. If that looks good to you I
> > suggest we post that as a series and ask Will and Catalin to take that
> > as-is.
> 
> Yes, please post those to the list for review.

Sure; I'm just prepping that now...

Mark.

