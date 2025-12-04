Return-Path: <live-patching+bounces-1894-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A04ECA2425
	for <lists+live-patching@lfdr.de>; Thu, 04 Dec 2025 04:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 79B023041115
	for <lists+live-patching@lfdr.de>; Thu,  4 Dec 2025 03:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E682C15A2;
	Thu,  4 Dec 2025 03:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RHFC/bKn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E462522A7;
	Thu,  4 Dec 2025 03:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764819150; cv=none; b=XslBAyxg7ob4jMjwvvcsj6Gr//bH2jDZ9f2TqzOp5wf1DnGD1ZSVL/TYLANsqAXwP0bucpQQXsKAm9kfO3Wf5OmZPK6YvoROT8IXvP0czZQIxN0i+VFVGf8msdC/AraJ/uY3XcYwb5D6ZOdSqZhV+SGexLIZAv3+Lij7mGitk1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764819150; c=relaxed/simple;
	bh=Z1y6Lo5N9JdICkvs25TdLiuXgMTj9YwnsJXYIxCQxUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ygpr2r1FFLveblPYAa8LZen+FBXAgKhvzkRps76UGFj19aGELa+NataiIAfW2OuvjQf5B+iChz9EKQiL45bZ0HXMZ0OpOXJ9zTp0WsGvSytMq68RBTKZNO8DcEa7EeLQXZh1ZCc2mYpo7e6A7HnVbO2VT5CGoMPuwXBt4tzem64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RHFC/bKn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CC1C4CEF5;
	Thu,  4 Dec 2025 03:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764819150;
	bh=Z1y6Lo5N9JdICkvs25TdLiuXgMTj9YwnsJXYIxCQxUQ=;
	h=From:To:Cc:Subject:Date:From;
	b=RHFC/bKnciDa5xjrkk1bSWf5DXSmnhmHN3wjhxOmGnnoVK3d5jK3ibOFqiKvvJNAm
	 hC68gISnol8VdAVC+xCS54fE8oVZRUmMLmEPZG9AKWN5li/KcvrzFpfNy4KJc6nuHv
	 YjXL37ZtBy8HdzHGD2AFfNlAYQws5d5VjuS7n5F5bLMwo1CjhBsf2jhT0U/e4YBPGR
	 i07nn5zV2Vu8vzEj428tOLxzo/RL3Lp96xmSWns6MwZhT28fQ6e7M9JL8amBAOoC7B
	 82jIqUUw8zKG1TYu2yIn3UqvBukmeCan4QpS87nqxXFgNfjoq+MFO5twTCXx1zEa0p
	 yMkAtTyyMy6Yw==
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
Subject: [PATCH v2 0/2] bpf, x86/unwind/orc: Support reliable unwinding through BPF stack frames
Date: Wed,  3 Dec 2025 19:32:14 -0800
Message-ID: <cover.1764818927.git.jpoimboe@kernel.org>
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

Changes since v1 (https://lore.kernel.org/cover.1764699074.git.jpoimboe@kernel.org):
- fix NULL ptr deref in __arch_prepare_bpf_trampoline()

Josh Poimboeuf (2):
  bpf: Add bpf_has_frame_pointer()
  x86/unwind/orc: Support reliable unwinding through BPF stack frames

 arch/x86/kernel/unwind_orc.c | 39 +++++++++++++++++++++++++-----------
 arch/x86/net/bpf_jit_comp.c  | 12 +++++++++++
 include/linux/bpf.h          |  3 +++
 kernel/bpf/core.c            | 16 +++++++++++++++
 4 files changed, 58 insertions(+), 12 deletions(-)

-- 
2.51.1


