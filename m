Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC4E32305A
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 19:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhBWSNd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Feb 2021 13:13:33 -0500
Received: from linux.microsoft.com ([13.77.154.182]:60284 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbhBWSNc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Feb 2021 13:13:32 -0500
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8F0A520B6C40;
        Tue, 23 Feb 2021 10:12:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8F0A520B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1614103971;
        bh=sy1CSkf4NPTHdPtm6j5T9s2Pe4lqTfBSvIKFA247V6w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=K03r/VXlwk2jKpOAoakKfKTnk9GgZIaZ9RmcwGyE5/jK0n0yMqk9aGLaUFlg9nGS7
         vh8SAXoOZ99GbSj9QKLNVoO+IqAjd5RBtUqtEt0bMUmbji47YgJB/vCTRpw/4CcHaU
         lsSYlbqTz0gCx991Ir1S5iazzjKggR2/3oJBmQEU=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        jthierry@redhat.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 0/1] arm64: Unwinder enhancements for reliable stack trace
Date:   Tue, 23 Feb 2021 12:12:42 -0600
Message-Id: <20210223181243.6776-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <bc4761a47ad08ab7fdd555fc8094beb8fc758d33>
References: <bc4761a47ad08ab7fdd555fc8094beb8fc758d33>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

I have made an attempt to add some enhancements to the stack trace code
so it is a few steps closer to what is required for livepatch.

Unwinder changes
================

	Termination
	===========

	Currently, the unwinder terminates when both the FP (frame pointer)
	and the PC (return address) of a frame are 0. But a frame could get
	corrupted and zeroed. There needs to be a better check.

	The following special terminating frame and function have been
	defined for this purpose:

	const u64    arm64_last_frame[2] __attribute__ ((aligned (16)));

	void arm64_last_func(void)
	{
	}

	In this patch, the FP is set to arm64_last_frame and the PC is set
	to arm64_last_func in the bottom most frame.

	Exception/Interrupt detection
	=============================

	An EL1 exception renders the stack trace unreliable as it can happen
	anywhere including the frame pointer prolog and epilog. The
	unwinder needs to be able to detect the exception on the stack.

	Currently, the EL1 exception handler sets up pt_regs on the stack.
	pt_regs contains a stack frame field that can hold an FP and a PC.
	The exception handler chains this stack frame field along with other
	frames on the stack. In other words, the EL1 handler creates a
	synthetic exception frame. Currently, the unwinder does not know
	where this exception frame is in the stack trace.

	In this patch, the LSB of the exception frame FP is set. This is
	similar to what is done on X86. When the unwinder detects the frame
	with the LSB set, it needs to make sure that it is really an
	exception frame and not the result of any stack corruption.

	It can do this if the FP and PC are also recorded elsewhere in the
	pt_regs for comparison. Currently, the FP is also stored in
	regs->regs[29]. The PC is stored in regs->pc. However, regs->pc can
	be changed by lower level functions. So, the PC needs to be stored
	somewhere else as well.

	This patch defines a new field, pt_regs->orig_pc, and records the
	PC there. With this, the unwinder can validate the exception frame
	and set a flag so that the caller of the unwinder can know when
	an exception frame is encountered.

	Unwinder return value
	=====================

	Currently, the unwinder returns -EINVAL for stack trace termination
	as well as stack trace error. In this patch, the unwinder returns
	-ENOENT for stack trace termination and -EINVAL for error. This idea
	has been plagiarized from Mark Brown.

Reliable stack trace function
=============================

arch_stack_walk_reliable() is implemented in this patch. It walks the
stack like the existing stack trace functions with a couple of additional
checks:

	Return address check
	--------------------

	For each frame, the return address is checked to see if it is
	a proper kernel text address. If not, the stack walk fails.

	Exception frame check
	---------------------

	Each frame is checked to see if it is an EL1 exception frame.
	If it is, the stack walk fails.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>

Madhavan T. Venkataraman (1):
  arm64: Unwinder enhancements for reliable stack trace

 arch/arm64/include/asm/processor.h  |   2 +
 arch/arm64/include/asm/ptrace.h     |   7 ++
 arch/arm64/include/asm/stacktrace.h |   5 ++
 arch/arm64/kernel/asm-offsets.c     |   1 +
 arch/arm64/kernel/entry.S           |  14 +++-
 arch/arm64/kernel/head.S            |   8 +--
 arch/arm64/kernel/process.c         |  12 ++++
 arch/arm64/kernel/stacktrace.c      | 103 +++++++++++++++++++++++++---
 8 files changed, 137 insertions(+), 15 deletions(-)


base-commit: e0756cfc7d7cd08c98a53b6009c091a3f6a50be6
-- 
2.25.1

