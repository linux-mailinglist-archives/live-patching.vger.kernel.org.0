Return-Path: <live-patching+bounces-81-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A5B7813BF8
	for <lists+live-patching@lfdr.de>; Thu, 14 Dec 2023 21:49:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D9D31F221A4
	for <lists+live-patching@lfdr.de>; Thu, 14 Dec 2023 20:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC3E31F926;
	Thu, 14 Dec 2023 20:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="F80+XtaM"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2CE273FB;
	Thu, 14 Dec 2023 20:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.4.26] (unknown [47.186.13.91])
	by linux.microsoft.com (Postfix) with ESMTPSA id AC61F20B3CC1;
	Thu, 14 Dec 2023 12:49:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AC61F20B3CC1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1702586971;
	bh=c1MPo0/TJVaQlWGGrusYNmJlcOO+AcMgdHja/aWIr80=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F80+XtaM631WSIJLPePnIezdTv5GQqUx8OMXB1BIuZ+jrRSIis5aOfo0YIUVT/gj0
	 XurkMlNPG0cvr4CJXX1aRBNj9sjsbNLLWgBTPQZBifv5TM1Z7z7UilfcQlxwZV+dkG
	 moo8ABBKUoRIq/r7T2d7JMy6BEu/dLYtuNkBgIIc=
Message-ID: <72364198-b031-4ecc-b337-d07db1b9d0c8@linux.microsoft.com>
Date: Thu, 14 Dec 2023 14:49:29 -0600
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: ARM64 Livepatch based on SFrame
To: Mark Rutland <mark.rutland@arm.com>
Cc: jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
 broonie@kernel.org, nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, jamorris@linux.microsoft.com,
 linux-arm-kernel@lists.infradead.org, live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
Content-Language: en-US
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

I attended your presentation in the LPC. You mentioned that you could use some help with some pre-requisites for the Livepatch feature.
I would like to lend a hand.

What would you like me to implement?

I would also like to implement Unwind Hints for the feature. If you want a specific format for the hints, let me know.

Looking forward to help out with the feature.

Madhavan

