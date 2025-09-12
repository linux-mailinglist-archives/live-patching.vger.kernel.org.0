Return-Path: <live-patching+bounces-1644-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2838B54055
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 04:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99BBA1726EC
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 02:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C381B0F19;
	Fri, 12 Sep 2025 02:26:13 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05CCB322E;
	Fri, 12 Sep 2025 02:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757643973; cv=none; b=bizQyk/IeHAZa64aI7dFUfGjynRiBcoXYWlspP/90Dmv8VI7vA0nyZ1D2ukX1X+nyP49VxnOwWnCzGzeE+XLjfQgQrpESWerKyLM6aWi9ZUz2Rf9XdGVYZKh+cStjNjdxRPhFEL/yBHfAn1DNkHWAlGcR7sHBIzJVNXAKDC8mcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757643973; c=relaxed/simple;
	bh=v4ZnAAgRrIZoT2rwuee+YKSyMUXAE5UC6+NNSIG6dHk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HcjylW2dwRrb/lTDjUP5Uiez8Vl3churxyenwnyK9i3XE1coDUfdbK6gjFxf2tEXHk3rEfTeAqTjhzz+36otPeSDlp2jaje3doSECuDoHHQ7GKRAJc86FJWSVVqQW4yqTzrgBWE0R2Ps98TAr/IPTDabsUfIw4fZb0NqqVyWcCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8CxJ9G+hMNoKngJAA--.20045S3;
	Fri, 12 Sep 2025 10:26:06 +0800 (CST)
Received: from [10.130.10.66] (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJDxQ+S9hMNoYVmPAA--.64958S3;
	Fri, 12 Sep 2025 10:26:05 +0800 (CST)
Subject: Re: [PATCH v1 1/2] livepatch: Add config LIVEPATCH_DEBUG to get debug
 information
To: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Huacai Chen
 <chenhuacai@kernel.org>, Xi Zhang <zhangxi@kylinos.cn>,
 live-patching@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250909113106.22992-1-yangtiezhu@loongson.cn>
 <20250909113106.22992-2-yangtiezhu@loongson.cn>
 <alpine.LSU.2.21.2509111549200.29971@pobox.suse.cz>
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <8dcdba05-4d8c-83ff-f337-b6e71546e1a0@loongson.cn>
Date: Fri, 12 Sep 2025 10:26:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2509111549200.29971@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxQ+S9hMNoYVmPAA--.64958S3
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7JF1fZFyfZFW7CrW5ZFy5trc_yoWDGwbEyr
	1xuwnrWa1UuFyq9a1fWr4avFWktw1kWryDXrn3ZryYvryqgFy5JrZYkF9IgrWrJrWjvF4D
	Kan5JFs3JryjgosvyTuYvTs0mTUanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbTAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa02
	0Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1l
	Yx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI
	0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4U
	MxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI
	0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE
	14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWU
	JVW8JbIYCTnIWIevJa73UjIFyTuYvjxU2MKZDUUUU

On 2025/9/11 下午9:50, Miroslav Benes wrote:
> Hi,
> 
> On Tue, 9 Sep 2025, Tiezhu Yang wrote:
> 
>> Add config LIVEPATCH_DEBUG and define DEBUG if CONFIG_LIVEPATCH_DEBUG
>> is set, then pr_debug() can print a debug level message, it is a easy
>> way to get debug information without dynamic debugging.
> 
> I do not have a strong opinion but is it really worth it? Configuring

This is an alternative way, there are some similar usages:

drivers/iommu/exynos-iommu.c:
#ifdef CONFIG_EXYNOS_IOMMU_DEBUG
#define DEBUG
#endif

drivers/mtd/nand/raw/s3c2410.c:
#ifdef CONFIG_MTD_NAND_S3C2410_DEBUG
#define DEBUG
#endif

drivers/usb/storage/usb.c:
#ifdef CONFIG_USB_STORAGE_DEBUG
#define DEBUG
#endif

> dynamic debug is not difficult, it is more targetted (you can enable it
> just for a subset of functions in livepatch subsystem) and it can also be
> done on the command line.

Yes, this is true. It is up to the maintainers to apply this patch
or not.

Thanks,
Tiezhu


