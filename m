Return-Path: <live-patching+bounces-107-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67A8381D6B4
	for <lists+live-patching@lfdr.de>; Sat, 23 Dec 2023 23:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E134283029
	for <lists+live-patching@lfdr.de>; Sat, 23 Dec 2023 22:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD3E171A7;
	Sat, 23 Dec 2023 22:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="JfFC1iuP"
X-Original-To: live-patching@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7196A168A8;
	Sat, 23 Dec 2023 22:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Received: from localhost (unknown [IPv6:2601:280:5e00:7e19::646])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 8D8D34E5;
	Sat, 23 Dec 2023 22:08:55 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 8D8D34E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1703369335; bh=huOwuWYusX/7wW3EH8MurgaAXdURnOfG8Q1+QitNm0U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JfFC1iuPyXau/7zdwYxy2Of+19JT9XbDjGYb9RnuvyQFnhkv6vqWNPnl+JHr3Jw6s
	 SjA30fUpvZK36Mtsn4tnXPXHLr/9JEGy5zmBx4lGyfgB1fDuODtN5aaPxj4ISV9Def
	 QMjP3a+BHdcvTqz2s661fhbkS+GA0n11NsBrmOP1spplt4WuXy2ER2uHF4/D3tLaxI
	 /dYlUVpSL6jWYVxcTX9Ka+d2SEwSrE65an4G1dHEn8ac+2KfmB+BXdZd19hAU2k/nu
	 8l5gqIuR95e201dj9YUQ5VJ6rFTXnGhMhK2h/KwytbfV3SEXfnqjOwr2M3x02qkYK4
	 vS0Gtg+cRWfXg==
From: Jonathan Corbet <corbet@lwn.net>
To: attreyee-muk <tintinm2017@gmail.com>, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com
Cc: attreyee-muk <tintinm2017@gmail.com>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation/livepatch: Update terminology in livepatch
In-Reply-To: <20231223205813.32083-1-tintinm2017@gmail.com>
References: <20231223205813.32083-1-tintinm2017@gmail.com>
Date: Sat, 23 Dec 2023 15:08:54 -0700
Message-ID: <87o7eg607d.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

attreyee-muk <tintinm2017@gmail.com> writes:

> Update the sentence in livepatch.rst to: "Functions are there for a reason. Take some input parameters, acquire or release locks, read, process, and write some data in a defined way."
>
> Signed-off-by: Attreyee Mukherjee <tintinm2017@gmail.com>
> ---
>  Documentation/livepatch/livepatch.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

So this is a classic example of saying what you have done, but not why.
What makes this a change that we want?

Also, please wrap your changelogs to a reasonable line length.

Thanks,

jon

