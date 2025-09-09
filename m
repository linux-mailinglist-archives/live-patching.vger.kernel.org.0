Return-Path: <live-patching+bounces-1632-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22715B4AC1B
	for <lists+live-patching@lfdr.de>; Tue,  9 Sep 2025 13:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7D04342D86
	for <lists+live-patching@lfdr.de>; Tue,  9 Sep 2025 11:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D880326D69;
	Tue,  9 Sep 2025 11:31:13 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A30322543;
	Tue,  9 Sep 2025 11:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757417473; cv=none; b=MzAZyxHF46eUdF7XYugyUvYzEW+No0y3wN9fQH23s9Rott8sfQhb5iEuYbXwLqy3NR3Wj2S4zRUfVa+BPbOWOI3TefyLJ/9Tzn+FrGkT8DiPXLBWb4q9s6kN5AKMv0SyxTCkjiAylh1UiSbbxdg+qTrHe0Po5nPzeAeH/L2LWiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757417473; c=relaxed/simple;
	bh=4mZ2zwX4COPPyKSVGRqkeqFFxo/eJVFLLK7KT40nWZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=spDWRVrSETSMfthdmUX1n+J3II8JdbIUydmQMbaBhLBWpQ0dPRV9uqh63/ZVlJE9O4rUVZwvGzBGPyN5DpguWq3/zwZwGrpFTm7gpcSBKNy4hUaWAhMzrGjkTFnqiEp77DD7haGudrq/EfacchhLG/J5MlXJZahxcspkIDqd4vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8Dx+tH8D8BosloIAA--.17980S3;
	Tue, 09 Sep 2025 19:31:08 +0800 (CST)
Received: from linux.localdomain (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJBxjcH7D8BoviGKAA--.57546S2;
	Tue, 09 Sep 2025 19:31:07 +0800 (CST)
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Xi Zhang <zhangxi@kylinos.cn>,
	live-patching@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] Debug and fix livepatch issues on LoongArch
Date: Tue,  9 Sep 2025 19:31:04 +0800
Message-ID: <20250909113106.22992-1-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxjcH7D8BoviGKAA--.57546S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29K
	BjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26c
	xKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vE
	j48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jYSoJUUUUU=

When testing the kernel live patching, there is a timeout over 15 seconds,
debug and fix the issues on LoongArch.

Tiezhu Yang (2):
  livepatch: Add config LIVEPATCH_DEBUG to get debug information
  LoongArch: Return 0 for user tasks in arch_stack_walk_reliable()

 arch/loongarch/kernel/stacktrace.c | 10 ++++++++++
 kernel/livepatch/Kconfig           |  8 ++++++++
 kernel/livepatch/transition.c      |  4 ++++
 3 files changed, 22 insertions(+)

-- 
2.42.0


