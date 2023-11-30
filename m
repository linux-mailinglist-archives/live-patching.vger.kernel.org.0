Return-Path: <live-patching+bounces-59-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2217FE495
	for <lists+live-patching@lfdr.de>; Thu, 30 Nov 2023 01:10:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 579041C209A9
	for <lists+live-patching@lfdr.de>; Thu, 30 Nov 2023 00:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01021385;
	Thu, 30 Nov 2023 00:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="ofNolQR8"
X-Original-To: live-patching@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FD3CA;
	Wed, 29 Nov 2023 16:10:28 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:280:5e00:7e19::646])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 89BDE377;
	Thu, 30 Nov 2023 00:10:26 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 89BDE377
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1701303026; bh=zIo8SV1c0ZhX3/iH2vn+LkvdDT3uPdZkOQTMoWU6W2U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ofNolQR8+2oE/pQInZdXqgK4Carg+5nVO8bylGqIbjVQkPjSjqUv9Qo7HLIWgQVhU
	 XUqTrYucnZt4OaltEVa/rNRI5CNQ4ZPGUEqmn3V+0fg+eI3NJAqIph8REEa3xO9CJ9
	 2XwclVX04py+M3rxTkJPLJAhkHBy2TOs18NtZeoEMKdFNnaecjQfctoCuSCNssrNam
	 I/doTjl3KlTd5eGDoNP3FwZmGWpYFaicXQItdAcgiA8dutZ/R8Mq2xIve+HVLsA5Hi
	 gPTAg0TnBWjoG/ESX9XQJBptGIrYXlisMABKf/lA0dvoGP5LCcU3yHR63l5xhgBtOC
	 1W/PIIuiE9maQ==
From: Jonathan Corbet <corbet@lwn.net>
To: Bagas Sanjaya <bagasdotme@gmail.com>, Joe Lawrence
 <joe.lawrence@redhat.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Documentation
 <linux-doc@vger.kernel.org>, Linux Kernel Livepatching
 <live-patching@vger.kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Attreyee
 Mukherjee <tintinm2017@gmail.com>
Subject: Re: [PATCH 0/2] Minor grammatical fixup for livepatch docs
In-Reply-To: <a4da77c2-7a23-4988-b65a-a58c105d89a4@gmail.com>
References: <20231129132527.8078-1-bagasdotme@gmail.com>
 <ac7a90a7-4d29-059b-fbff-6b67e6f5c2d3@redhat.com>
 <a4da77c2-7a23-4988-b65a-a58c105d89a4@gmail.com>
Date: Wed, 29 Nov 2023 17:10:25 -0700
Message-ID: <87h6l4ksni.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bagas Sanjaya <bagasdotme@gmail.com> writes:

> On 11/29/23 20:53, Joe Lawrence wrote:
>> On 11/29/23 08:25, Bagas Sanjaya wrote:
>>> I was prompted to write this little grammar fix series when reading
>>> the fix from Attreyee [1], with review comments requesting changes
>>> to that fix. So here's my version of the fix, with reviews from [1]
>>> addressed (and distinct grammar fixes splitted).
>>>
>> 
>> Typical kernel workflow would be for Attreyee to incorporate feedback
>> and post their v2 after a day or two.  From the format they posted, it
>> appears to be a first(ish) kernel contribution post.  Let's be kind and
>> patient so they we all may benefit from the practice of iterating on
>> their patch.
>> 
>
> I do this posting because I thought the OP (Attreyee) didn't respond in
> timely manner (just like random Chinese contributors like @cdjrlc.com
> and @208suo.com people).

Seriously?  The original post was on Monday, yours came less than 48
hours later.  Not only can we not expect that kind of rapid turnaround
from anybody, but we actively discourage rapid resending of patches.
Rather than dig yourself in deeper, I suggest you simply apologize to
the original poster and find something more useful to do.

Thanks,

jon

