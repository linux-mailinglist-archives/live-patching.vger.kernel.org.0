Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B83778C861
	for <lists+live-patching@lfdr.de>; Tue, 29 Aug 2023 17:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjH2POA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 29 Aug 2023 11:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbjH2PNi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 29 Aug 2023 11:13:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CC0B5
        for <live-patching@vger.kernel.org>; Tue, 29 Aug 2023 08:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693321968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=w3CVYpgxTsvHbKTea4nnprzsRm89plHSxyih6vxlw24=;
        b=Lq8lasQnnqxI8bvr0WCr2IZ0yYkEv5gsLhjDyUaJv/wH3WOgqsntBILX5+6gZjLHxhQU/3
        lVhPCwtrpHD4+lKOQI5E9i6gkfpcMAUFhvExznrj20j2xmPX6WsVBU1/Jk13ZKBTUatcbo
        fEhKMu5k4vQGrfae6LyrN0XJ8p/c0WE=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-xaklgDF5NhOHUji6ZcH9AA-1; Tue, 29 Aug 2023 11:12:44 -0400
X-MC-Unique: xaklgDF5NhOHUji6ZcH9AA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0194A1C03D96;
        Tue, 29 Aug 2023 15:12:44 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE4FD401051;
        Tue, 29 Aug 2023 15:12:43 +0000 (UTC)
Date:   Tue, 29 Aug 2023 11:12:42 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     live-patching@vger.kernel.org, Ryan Sullivan <rysulliv@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Recent Power changes and stack_trace_save_tsk_reliable?
Message-ID: <ZO4K6hflM/arMjse@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi ppc-dev list,

We noticed that our kpatch integration tests started failing on ppc64le
when targeting the upstream v6.4 kernel, and then confirmed that the
in-tree livepatching kselftests similarly fail, too.  From the kselftest
results, it appears that livepatch transitions are no longer completing.

Looking at the commit logs for v6.4, there looks to be some churn in the
powerpc stack layout code -- I am suspicious that "reliable" stack
unwinding may be left untested/broken after those changes.  AFAICT, the
livepatching subsystem is the only user of this interface in
kernel/livepatch/transition.c :: klp_check_stack()'s call to
stack_trace_save_tsk_reliable().  As such, the livepatching kselftests
are probably the only way to test reliable unwinding.

Unfortunately, git bisect isn't cooperating (we keep falling into a long
span of non-bootable commits, despite efforts to `git bisect skip` over
them), so we don't have an offending commit or patchset to point to.

A few other details:

- Test machine is a Power 9 9009-42A (IBM Power System S924)
- Reproducable with v6.4, v6.5
- Minimal repro:
-- Build with CONFIG_TEST_LIVEPATCH=m
-- Run tools/testing/selftests/livepatch/test-livepatch.sh

If this has already been report or fixed, please send any pointers to
threads / commits.  If not, I can provide any other info to help
reproduce.

Thanks,

--
Joe

