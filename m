Return-Path: <live-patching+bounces-1841-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1097FC54CF5
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 00:32:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AD84C4E022E
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 23:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285E56BB5B;
	Wed, 12 Nov 2025 23:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXXKO+y0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E776535CBC1;
	Wed, 12 Nov 2025 23:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762990363; cv=none; b=ZhrREGcOeEahE4atuZFLDUPE8I36JxZnAh2+B4S+/IyN9jIAQIfpyy8r/Qz6SJRqCf+vib83C+vKpf9lFJF8Ql/lv4YD45nQAFqLgEqR9BS1oNW+uqVa7KVlORt4czwvCA/l0griV3c7PKbRsDEf86UxWEDeFQHkPbn8TFdLujo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762990363; c=relaxed/simple;
	bh=YxVh3ksQ/LqVSGcKf4ZNRY225lTdws6Ge7FfpS0jmWM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DMXwTzHeNvmvb2tB57xCqUSvgfKuuE83KNJfBWxjLOKqEJEMo5uABcRBkSghUfH0xO+9qtj4DTewbmVDIjmQsGwPJZA+c2X7QANGyOSNX6OP+CO5sQbB7NYwa9QIRT8Xqs0I036grRIRnXyR2HfCt+nAv/Bcl0WmPrF0IKaVOEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXXKO+y0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C51BC4CEF1;
	Wed, 12 Nov 2025 23:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762990362;
	bh=YxVh3ksQ/LqVSGcKf4ZNRY225lTdws6Ge7FfpS0jmWM=;
	h=From:To:Cc:Subject:Date:From;
	b=QXXKO+y0jR3j6Xas36nDQAUZmX/C+UumyptqLinWUZrInz009doZ+hUMzd9a0pG3q
	 xMY+r5JsdTimApfkuaQD7dkt2c7OLwedHQJFsLpjvnhcQRC7IqVgI2caM8DDgc06+q
	 ZJKmm/06gOE8G9AUHIWhav1dDri7SVCHBqg+bqVQKX3WrepEQIq45PTRnOclbwpIl2
	 us0he0Pv0TOUatlM+RW1HkFT0r5f2kWwHW7yNk7HZoIwmL1+A35O5tCN9Udd0apML4
	 EUW0rddgnGqIqrx6e+RgYM66X5//b9RiYIs/cPd/T4/Fs8pbXf6YBLSFf6F7n4IyKs
	 RDkPMaSjf+dBw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Michael Kelley <mhklinux@outlook.com>,
	live-patching@vger.kernel.org
Subject: [PATCH 0/2] objtool: xxhash dependency improvements
Date: Wed, 12 Nov 2025 15:32:32 -0800
Message-ID: <cover.1762990139.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set the minimum xxhash version to 0.8, and soften the xxhash dependency
a bit so that it's only needed when running klp-build rather than doing
a normal kernel build.

For tip/objtool/core.

Josh Poimboeuf (2):
  objtool: Set minimum xxhash version to 0.8
  objtool/klp: Only enable --checksum when needed

 arch/x86/boot/startup/Makefile | 2 +-
 scripts/Makefile.lib           | 1 -
 scripts/livepatch/klp-build    | 4 ++++
 tools/objtool/Makefile         | 2 +-
 tools/objtool/builtin-check.c  | 2 +-
 5 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.51.1


