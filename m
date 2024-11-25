Return-Path: <live-patching+bounces-864-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 322739D8547
	for <lists+live-patching@lfdr.de>; Mon, 25 Nov 2024 13:19:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CEA18B44A6C
	for <lists+live-patching@lfdr.de>; Mon, 25 Nov 2024 11:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A621A3035;
	Mon, 25 Nov 2024 11:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NJUVo3MQ"
X-Original-To: live-patching@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64F119E819
	for <live-patching@vger.kernel.org>; Mon, 25 Nov 2024 11:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732534113; cv=none; b=MoJPhRDZKX8UdNICqlqqUF03uB8oPWZ5SKBzy6JkmCmodW3DkVSqqDO4Md1SS+fNNyrCuiDMF0Uk1AkOXE9ExwT6MXvndQZ3HxMVySDkNRJbl0K7z+wdZHl3UJYRn4JAbz/IHYwHzlPJ45Nd+sEf3vi1xh2R6hciaRu4hBjeVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732534113; c=relaxed/simple;
	bh=8+WrTeIjHJDsvO6eNUfMcipH42y2RHwqgZd720PD++E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g5OmF3AOSp993xNQmYu/t7aSuKuf40zQ5aovqyXtDFgFA0DwOJM7NqG0L1d6RacRTivvCO7umoWV0mF+aF/7ACm44KbrO/PaImNXIcRljltkMKRbc+d7QNFyFqO997bohHCv1+vtt2PbgHQQ9K9b4R73pzFR7wHmieDatvGdv/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NJUVo3MQ; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732534109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X4iiNlDUMS/v/1sWsQak88i5dwU1nxdsRUlCF1jU/hk=;
	b=NJUVo3MQ7dgQTljsVnJm87JCU5R42RgqSjNOH2rCQGRqUHTyI6MAh9a4l0+XT1DaB4V5FL
	1I/UlkxLKWv/4eB4xdGWaAtwp/oxkGloutT53YMaLwyrU4wlmDRsKney/gp7w+msT9Of2T
	hI8AbPHzJDDBr9ijXSyeP54lpGChz30=
From: George Guo <dongtai.guo@linux.dev>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	shuah@kernel.org
Cc: live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH livepatch/master v1 2/2] selftests/livepatch: Replace hardcoded module name with variable in test-callbacks.sh
Date: Mon, 25 Nov 2024 19:28:12 +0800
Message-Id: <20241125112812.281018-2-dongtai.guo@linux.dev>
In-Reply-To: <20241125112812.281018-1-dongtai.guo@linux.dev>
References: <20241125112812.281018-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: George Guo <guodongtai@kylinos.cn>

Replaced the hardcoded module name test_klp_callbacks_demo in the
pre_patch_callback log message with the variable $MOD_LIVEPATCH.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 tools/testing/selftests/livepatch/test-callbacks.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index 32b150e25..150cb68fe 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -259,7 +259,7 @@ $MOD_TARGET: ${MOD_TARGET}_init
 % insmod test_modules/$MOD_LIVEPATCH.ko pre_patch_ret=-19
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
-test_klp_callbacks_demo: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH: pre_patch_callback: vmlinux
 livepatch: pre-patch callback failed for object 'vmlinux'
 livepatch: failed to enable patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': canceling patching transition, going to unpatch
-- 
2.43.0


