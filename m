Return-Path: <live-patching+bounces-1203-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0803A365AD
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 19:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79A7E189497F
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 18:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B868B2686B3;
	Fri, 14 Feb 2025 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ke+Lu86I"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A13A14D28C;
	Fri, 14 Feb 2025 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739557484; cv=none; b=O6ctj9dZ6SvtHfPs83bnYT5DOwZXQvfl4SrlVkb7AP9ziLtqq55yd29dbml6ZHKNgZJ00966bRbZtv49ZvirHAk2O5dioe0zt+IsN8IoWIWkYhB/OmOaWgcoTFwxpmMHacOcT/Fsx3M8+i5i8XHGxzWFNLG3RbOz077nTdkrbSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739557484; c=relaxed/simple;
	bh=qcahaJjxOPF2+xYUsg3HR7q67xvZO5cp5xgsBNVsZHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NuN+YdXCqfzvala/TxA20YT57OJwtB83PNSD6gVlHWE2/NiCK6tFzRBeKALz02zeT6eFwh8yyzrvW54btXF4+q+SxQHVz1Kwn/lIm+GfN41+l/NWcJqp65rhWU0veiMh8AqORpAxUbXD9yp90HvW/L1S6BZZMvMMxGPBUqJtnwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ke+Lu86I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859E2C4CED1;
	Fri, 14 Feb 2025 18:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739557481;
	bh=qcahaJjxOPF2+xYUsg3HR7q67xvZO5cp5xgsBNVsZHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ke+Lu86Il0gbEC9tvWXHdbBP12IpV/yk43MGmN22VmqWWg7AjL/L3fiXu7UldG2S2
	 7OOwCshZ10vkxyVym1yTfLX3/6RfULL2PR78xdqFADvHg6utE68b6hr6SRLfrkzi0o
	 tHtoY6Ur0EiBk62ptu5WrOO9irskzDoIJdeGKbCywGOhp/C4eJ1ZE8JZX4MCne3aA6
	 TbVz8lpq//Q5XQ9DVJAHogt6OmzRsxohuie/uv0/deRI+WjJmtw2El6b7vWPxW7PdB
	 SOX7GLgM+sNTeH793CsYEDo3WX8A6o3xt7TNFuYI53lNT6cBf80hKHBVhC6Lz3J9aG
	 KCf5Kd4maN3yw==
Date: Fri, 14 Feb 2025 10:24:39 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Puranjay Mohan <puranjay@kernel.org>
Cc: Song Liu <song@kernel.org>, Indu Bhagat <indu.bhagat@oracle.com>,
	Weinan Liu <wnliu@google.com>, Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20250214182439.gpavslsvgw4xy7sf@jpoimboe>
References: <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com>
 <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
 <mb61p1pw21f0v.fsf@kernel.org>
 <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
 <mb61pseoiz1cq.fsf@kernel.org>
 <CAPhsuW7bo4efVYb8uPkQ1v9TE95_CQ6+G3q4kVyt-8g-3JD6Cw@mail.gmail.com>
 <mb61pr0411o57.fsf@kernel.org>
 <CAPhsuW7fBkZaKQzLvBqsrxTvpJsfJfUBfco4i=-=C_on+GdpKg@mail.gmail.com>
 <mb61p7c5sdhv6.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <mb61p7c5sdhv6.fsf@kernel.org>

On Fri, Feb 14, 2025 at 08:56:45AM +0000, Puranjay Mohan wrote:
> I did this test and found the same issue as you (gdb assembly broken),
> but I can see this issue even without the inlining. I think GDB tried to
> load the debuginfo and that is somehow broken therefore it fails to
> disassemblt properly.

I had the same theory about the debuginfo, but I stripped debug sections
from that file and gdb still got confused.

Still, the symbol table looked normal, so the gdb issue might be
completely separate from the kernel runtime issues.

-- 
Josh

