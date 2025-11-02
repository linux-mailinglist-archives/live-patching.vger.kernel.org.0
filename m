Return-Path: <live-patching+bounces-1830-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B85C29A39
	for <lists+live-patching@lfdr.de>; Mon, 03 Nov 2025 00:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8B5E24E27EF
	for <lists+live-patching@lfdr.de>; Sun,  2 Nov 2025 23:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D32F1DDC2C;
	Sun,  2 Nov 2025 23:39:32 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41828479;
	Sun,  2 Nov 2025 23:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762126772; cv=none; b=N1mq1gI+zSZ09Zu3T/HBpGLC43NkkRFHYyddej84YGoSHk6BrL4rw0S10x3t/NRpw7FPawendIySOLW1ntQJQZanYTqHNNeov4Fh+m4Wx7CBpij3CYbwg9Sen+JYP8+k2pTnpKiAg1lsXuhCczlvpR80RFv/g8GGIRaxB7LC75c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762126772; c=relaxed/simple;
	bh=JTfg5wvOSSMbGw1iWuRfnXsinP4kfZYRB9vwpqILAaU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b3M2zeMz8+TVuw/Uinr60Iz8a/DiKA5dahyyWcvKLFxZhNUm5DzVI2wWRe9bZDBMGS84JgBo29pCpPQXGjpT0GwFVaWAF/q8bKaMVXlzIYdRjzxR5OEDY2CXc0g9Ns9eR3Xx8rzkQs8FaIi8arQYkZuVO3vt2SUBGEol7VHKPfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD1D6BC356;
	Sun,  2 Nov 2025 23:39:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 294328000F;
	Sun,  2 Nov 2025 23:39:19 +0000 (UTC)
Date: Sun, 2 Nov 2025 18:39:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
 linux-trace-kernel <linux-trace-kernel@vger.kernel.org>,
 live-patching@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Kernel Team <kernel-team@meta.com>, Jiri Olsa
 <olsajiri@gmail.com>
Subject: Re: [PATCH v4 bpf 0/3] Fix ftrace for livepatch + BPF fexit
 programs
Message-ID: <20251102183921.795946be@gandalf.local.home>
In-Reply-To: <20251101091116.763638e5@batman.local.home>
References: <20251027175023.1521602-1-song@kernel.org>
	<CAADnVQ+azh4iUmq4_RHYatphAaZUGsW0Zo8=vGOT1_fv-UYOaA@mail.gmail.com>
	<20251101091116.763638e5@batman.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7hjd5wcb3154th1rxqr7wftcoqzt44rm
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 294328000F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+MZt+rdSRgoLOtePwqldmbMJy0Z1jMA4A=
X-HE-Tag: 1762126759-668126
X-HE-Meta: U2FsdGVkX19mfh72onqb0owf+ocMTCDYMD3aP0mt79d0BWncj7+ru83fkYRqz9nfVJPRGPSqpVgAsjW5MDKSSH44tlZUIowwrsiIi9w1Pgv6eegWJVZzLbRPv4tl+n9T7GsKNHejqyRlMbA1hd5txjIia1wcuwWku5NEgoagozrJ5KBwUNUkr1HsB/pa9JTqkoD0AhexbY82WXbhq+p5cGhiXj5EyXve1iPnw6iHH5tnE/pVoe4psS4z4vb0PvYmcyVceS3Q5c/nU/Iku3FRAKGGBocuLboNkSj3DYCil3qe/J1MVhhvSmbvbgiuEIWOt4t748JQIYdK8D6Xx0x0APo2mdTcTHR+sUTiW8CjoMLd56H7KBtOFAM/cUMRNSAUAtl4Ofb7iUhz0dpry6F+Xg==

On Sat, 1 Nov 2025 09:11:16 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 31 Oct 2025 17:19:54 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > can you apply the fixes or should I take them ?
> > If so, pls ack.  
> 
> Let me run them through my full test suite. It takes up to 13 hours to
> run. Then I'll give a ack for you to take them.
> 

They passed my tests.

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Feel free to send them through the BPF tree.

-- Steve

