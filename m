Return-Path: <live-patching+bounces-1862-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E313C6693F
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 00:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6036C4EF107
	for <lists+live-patching@lfdr.de>; Mon, 17 Nov 2025 23:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8E2326D67;
	Mon, 17 Nov 2025 23:42:13 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC00031690D;
	Mon, 17 Nov 2025 23:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763422933; cv=none; b=eotnp/wMHLzg6vcIrK1oWVnQY79pDVf7FsP762ZS7EOa2uj2Wem+M0hgJMWukuFezhj+9k/NfsnCAoLG9TxW+ATjWl6u5Thkb5x0DpQjn+VV9lno69NXxas0r5ejYI4sfQ0ZyNXupAvOHF312R7VYJtI1X6xkd4jml7O3pTEkHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763422933; c=relaxed/simple;
	bh=YRpRmnDca/3gsrMbdLaQlrHsNjr7i3hJ0M7mtQ+KBHo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GzIVhDmx9estbYURuceWMoI3IoTMyCydDeL8CZCNawS7Wc/wWBZpNgIyvV3QHLoTVWShyuJMTUwxN7xNTpgRZU6JlPQklR1iSq7WyM3NxTENe5/u+s9eDLUTyaHv1m/VzAG5aev2NfwBQyQuoPMoWE62OpWZAb1glxnghuJ9CfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D69B8140316;
	Mon, 17 Nov 2025 23:42:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 11FF82000E;
	Mon, 17 Nov 2025 23:41:57 +0000 (UTC)
Date: Mon, 17 Nov 2025 18:42:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Puranjay Mohan
 <puranjay12@gmail.com>, Song Liu <song@kernel.org>, Indu Bhagat
 <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Will
 Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Jiri
 Kosina <jikos@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>, Ian
 Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 joe.lawrence@redhat.com, Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20251117184223.3c03fe92@gandalf.local.home>
In-Reply-To: <nzmtsafrx5vjitgfpducjaa7kq747a3sler2vvyvfbxecutn3v@7ffl2ycnaoo2>
References: <20250904223850.884188-1-dylanbhatch@google.com>
	<CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
	<CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
	<CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com>
	<nzmtsafrx5vjitgfpducjaa7kq747a3sler2vvyvfbxecutn3v@7ffl2ycnaoo2>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 11FF82000E
X-Stat-Signature: 69j1omukhijmws83usqedd19xow934xf
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/RSRttW0w+uL7MmExm2Uube7v/Le1ObPU=
X-HE-Tag: 1763422917-701968
X-HE-Meta: U2FsdGVkX1/5K/x9LBC/WWNoAHjc68zPK6/H7BtcbuJYW5CszdZUO+s+yUdtqvlxZLFQyagMiIRMjZTmOjOn5JLVTrJonObD2GVhiCIunynfDJeKNGv3yflgVLu/ZSqRbK9AyaKo0xUQ0+VE4qkbTHwowP7AAuzifv0lX7VY6/tIYMgeB16ILGoweyFEUAbOeKHRtXeFVTLtPTXbpadao67KdnAwTbmTwxN3mTe1ZAMnp0bouhLNoIVl8E1lZeno7cg9QFNb54dnWRKsR6gjwzsRAzJA+YQfEYxZilYZsqLWcmde5QWyNVbz9YrNNctsaln6kgE94omdkH8fHAVWsfU44uzhk1SgJBbyGKkZpy9ezx1aldt0OQ==

On Mon, 17 Nov 2025 15:06:32 -0800
Josh Poimboeuf <jpoimboe@kernel.org> wrote:

> The ORC unwinder marks the unwind "unreliable" if it has to fall back to
> frame pointers.
> 
> But that's not a problem for livepatch because it only[*] unwinds
> blocked/sleeping tasks, which shouldn't have BPF on their stack anyway.
> 
> [*] with one exception: the task calling into livepatch

It may be a problem with preempted tasks right? I believe with PREEMPT_LAZY
(and definitely with PREEMPT_RT) BPF programs can be preempted.

-- Steve

