Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC6E223D98
	for <lists+live-patching@lfdr.de>; Fri, 17 Jul 2020 16:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgGQOEg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jul 2020 10:04:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47001 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726696AbgGQOEf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jul 2020 10:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594994675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ngwVhwuIZ9N8nKS6j+ofJuXNHDXl3d76opbHIrcwguI=;
        b=bySGNLpaMZVQqMVB3sfPCDkwiQ+XILP9OOGvBbrtYthKsES7FMco6VRM3nyXeiNec6JCsu
        KL/HthdXtpkbEtqf1qE41yWIXMxFhmtFltTFiiz/Eg2dFuKBeFjyHDeWPt4Xgcl786xAwq
        qZGPkSEc5drxyVVTvbuFp2H/8upz7sM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-Jbaj011tOHKhkci7uVfqMw-1; Fri, 17 Jul 2020 10:04:32 -0400
X-MC-Unique: Jbaj011tOHKhkci7uVfqMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 757FA18A1DE1;
        Fri, 17 Jul 2020 14:04:30 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-144.rdu2.redhat.com [10.10.118.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C117D6FEF8;
        Fri, 17 Jul 2020 14:04:29 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>
Subject: [PATCH 0/2] x86/unwind: A couple of fixes for newly forked tasks
Date:   Fri, 17 Jul 2020 09:04:24 -0500
Message-Id: <cover.1594994374.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

A couple of reliable unwinder fixes for newly forked tasks, which were
reported by Wang ShaoBo.

Josh Poimboeuf (2):
  x86/unwind/orc: Fix ORC for newly forked tasks
  x86/stacktrace: Fix reliable check for empty user task stacks

 arch/x86/kernel/stacktrace.c | 5 -----
 arch/x86/kernel/unwind_orc.c | 8 ++++++--
 2 files changed, 6 insertions(+), 7 deletions(-)

-- 
2.25.4

