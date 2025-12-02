Return-Path: <live-patching+bounces-1885-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86C26C9C99E
	for <lists+live-patching@lfdr.de>; Tue, 02 Dec 2025 19:20:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44AA23A0FE2
	for <lists+live-patching@lfdr.de>; Tue,  2 Dec 2025 18:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACDCC2BDC27;
	Tue,  2 Dec 2025 18:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jvf2sfPZ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC4221C9E5;
	Tue,  2 Dec 2025 18:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764699645; cv=none; b=ilCslB+JrWAHIJ+xpVAR9RR1G13zd3aUW0Fc1EEk6RRH7RUXUgR35Thczl5w7c4f/nDkswYW/jIOV/q+M5IxiWjDcQenk2FOqZ6ZJL5FCcs/fgY46tIjciFBjATGC2Z+S4xAC4mnu9JWA+CpuUL6X1Mgol0tXbuhNU9z583ZERE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764699645; c=relaxed/simple;
	bh=kLwNwpHVpLRa7Qyf9zwl9tMTIMo12JxS3eH10qwonPo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iw5aAQWEGUtUP0MJyk7K1uJxWYLejDkIGT3n7pE6OrR/pVn0ie3/BzbymgvBI88x0z7r61l753/64HSZR47gCfSLg4TKRxrypwcUNMW7rBPkcv94Xkss+grQq2W8AfP1tDlcW0JBqmRaXhRFKF8tH+x7sUY2eEVJsn1hAAzyvvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jvf2sfPZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C859C4CEF1;
	Tue,  2 Dec 2025 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764699645;
	bh=kLwNwpHVpLRa7Qyf9zwl9tMTIMo12JxS3eH10qwonPo=;
	h=From:To:Cc:Subject:Date:From;
	b=Jvf2sfPZnlTfr5dz6doQuVDI9wuPHuJ/gemlxA3GDr9JvOU3ZhHl3z8at2BLTQrSq
	 tnGqvVOqJi9k9vVQlL6iWGOJ+C+1YqwgXVv0mKSY8B4QEp8E25r9rwwxjueIkw77zo
	 1sIkOY4nGTnorEJnlyH+rTPWYCdYqfD1+w9/P71OgbaH01sMstNSb9fqqFOZgSWJBf
	 th+aEoUZ2F1TzoFJJ0cKU4uTXo2lVkapdhT3BNV/Mw9xUyfIZV4UCpgBGTH++eWvit
	 yjIW4TETZixzoW7ndnGoe0ck0S6pWxv6VhZNypH8c/iZYkoHQABegR6eHoxsrXtmFK
	 CpCSqkwcOsa1g==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	bpf@vger.kernel.org,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	Petr Mladek <pmladek@suse.com>,
	Song Liu <song@kernel.org>,
	Raja Khan <raja.khan@crowdstrike.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/2] bpf, x86/unwind/orc: Support reliable unwinding through BPF stack frames
Date: Tue,  2 Dec 2025 10:19:17 -0800
Message-ID: <cover.1764699074.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix livepatch stalls which may be seen when a task is blocked with BPF
JIT on its kernel stack.

Josh Poimboeuf (2):
  bpf: Add bpf_has_frame_pointer()
  x86/unwind/orc: Support reliable unwinding through BPF stack frames

 arch/x86/kernel/unwind_orc.c | 39 +++++++++++++++++++++++++-----------
 arch/x86/net/bpf_jit_comp.c  | 10 +++++++++
 include/linux/bpf.h          |  3 +++
 kernel/bpf/core.c            | 16 +++++++++++++++
 4 files changed, 56 insertions(+), 12 deletions(-)

-- 
2.51.1


