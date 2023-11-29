Return-Path: <live-patching+bounces-54-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77EB27FD966
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 15:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9D2D1C20AED
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 14:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF70C315B3;
	Wed, 29 Nov 2023 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="abXxMwtJ"
X-Original-To: live-patching@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DA5173F;
	Wed, 29 Nov 2023 06:29:37 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:280:5e00:7e19::646])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 50CE037A;
	Wed, 29 Nov 2023 14:29:36 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 50CE037A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1701268176; bh=nBZchssDZ6Eyz0mpW9mYTJOi1nU2SQQKig5pHaps0S4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=abXxMwtJ4WQmFsjUs9w2OqJqBmXQXtHaXEwDpPw4zHeilK/RIY7ULPtzPZrFKkeEX
	 jtXuLmScg1feFawPT9cyxzbiGoI8vlk8ksSq1hd3p7Pl/oUZv9Am2vv/MtFHU7MR/i
	 0NgB5zMJXCUvbpC9GNmFW/prrdtM5BcIA6rJhr8Z228EY7kGD2TKDrWJMg8u74k2pR
	 mBZdWgZ0cWd+4U3p0e1ARIsoIgdWngglDLQjI4pdX2HM4pZIqR/nJKLrMEkAkfl+Tw
	 EMoBmbnM8Y8VAFPJ1fpUFw0W1JjNHNT+oA4Yasw18qMJ3v7JXeEW0YVxGNpEmJqtT/
	 gbP13Nec8th8Q==
From: Jonathan Corbet <corbet@lwn.net>
To: Bagas Sanjaya <bagasdotme@gmail.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Documentation
 <linux-doc@vger.kernel.org>, Linux Kernel Livepatching
 <live-patching@vger.kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe
 Lawrence <joe.lawrence@redhat.com>, Attreyee Mukherjee
 <tintinm2017@gmail.com>, Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 0/2] Minor grammatical fixup for livepatch docs
In-Reply-To: <20231129132527.8078-1-bagasdotme@gmail.com>
References: <20231129132527.8078-1-bagasdotme@gmail.com>
Date: Wed, 29 Nov 2023 07:29:35 -0700
Message-ID: <874jh4pr8w.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bagas Sanjaya <bagasdotme@gmail.com> writes:

> I was prompted to write this little grammar fix series when reading
> the fix from Attreyee [1], with review comments requesting changes
> to that fix. So here's my version of the fix, with reviews from [1]
> addressed (and distinct grammar fixes splitted).

How is this helpful?  Why are you trying to push aside somebody who is
working toward a first contribution to the kernel?  This is not the way
to help somebody learn to work with the kernel community.

Attreyee, I would like to encourage you to redo your patch set based on
the feedback you have received so that we can apply it.

Thanks,

jon

