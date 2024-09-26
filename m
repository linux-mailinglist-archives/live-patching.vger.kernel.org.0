Return-Path: <live-patching+bounces-686-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D24D987733
	for <lists+live-patching@lfdr.de>; Thu, 26 Sep 2024 18:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95440B26ABF
	for <lists+live-patching@lfdr.de>; Thu, 26 Sep 2024 16:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2E31552E4;
	Thu, 26 Sep 2024 16:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="RjrTB08B"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10951BC4E;
	Thu, 26 Sep 2024 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727366699; cv=none; b=l/NO0hIxZmSpgj9N6uR5aYD7TsqB23Bd6bG2LinMJV4Cv4pIBVs92uf4ANFU7Yaz8/bHaGRzCLR/RINy6zaCR7NbarikmkcesMmwAE9U+MiVJ6uLI5aZHfhyJruAfwbA/BvdIFgVLMYf7Wgdmz0pkbQtJYOFKyvbgSVd2ONE51c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727366699; c=relaxed/simple;
	bh=jAfRZWtbHha+ZCIX8H7HnBlAhgRyHfe0RC770fEeDxc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=PhuTf495fpjAvMJxuCLb1Ihr+MmcTjXlrStWymMvibr/kgUXrWgpvLlv7n7litIpyQb5lAPEbKg42w+dSLRtGwcG43CXXOVzhFCZHVHQkjUFqwNFslOzbiZrKzCwFUTjJO4rasUoeGXTUD4pVgReUqK6daE0kLbOIgn6bMJ9aqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=RjrTB08B; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.79.128.42] (unknown [4.194.122.170])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2A91220C77CB;
	Thu, 26 Sep 2024 09:04:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2A91220C77CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1727366698;
	bh=jAfRZWtbHha+ZCIX8H7HnBlAhgRyHfe0RC770fEeDxc=;
	h=Date:To:Cc:From:Subject:From;
	b=RjrTB08BWbHoXYLtLbvyHmhnu7NMH5b+hbfMDMMuSdgx6Z+ZOPhdUb+Zkb6mRwVIa
	 7u4V2w2Z1rzbRqvzGux9G88NM9fk8Dl7TYWfg2gGazWLxcqSbI6icqJqabwFs4A3z/
	 tQcMtE51kL8LgYwzy8dP6HoYotOI6L+Iqb0GoPGI=
Message-ID: <8e02ed1a-42a9-41ab-b1b4-cb5e66bf4018@linux.microsoft.com>
Date: Thu, 26 Sep 2024 21:34:50 +0530
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To: mark.rutland@arm.com
Cc: madvenka@linux.microsoft.com, jpoimboe@redhat.com, peterz@infradead.org,
 chenzhongjin@huawei.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
 sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
 live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
 kpraveen.lkml@gmail.com, kumarpraveen@microsoft.com
From: Praveen Kumar <kumarpraveen@linux.microsoft.com>
Subject: ARM64 Livepatch based on SFrame
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

Hope you are doing great.

I am interested to work on ARM64 livepatching using SFrame, and thus, reinitiating the old thread (Link: https://lore.kernel.org/all/ZXxO43Xwn5GHsrO8@FVFF77S0Q05N/).

Please do let me know if there anything which I can help with, in developing this feature. Thanks.

Regards,

~Praveen.



