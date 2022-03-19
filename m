Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA6D4DE96A
	for <lists+live-patching@lfdr.de>; Sat, 19 Mar 2022 17:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243662AbiCSQxc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 19 Mar 2022 12:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243223AbiCSQxc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 19 Mar 2022 12:53:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 213273DA51
        for <live-patching@vger.kernel.org>; Sat, 19 Mar 2022 09:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647708730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=saWneBVb3Kut4BG7sQxMXnQsPh0IPbc8oGB5dOPI5bM=;
        b=A2JragjGK72gSzh9Mvj28xvIm3K9UUON7ZcZELrAO8Jrq7AwpnzX4YcAZMdJvv1b8rANOD
        AS1dIhpveIap+0hoRwYqtqLCnCebeWb70FQMGSLYHB2lG1ZZtkOppFSfTEJGxuf7dzCKBu
        SS7sjc9US/BpP3//usTbK4bW5znc8rU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-NxKe_C5BMxqSBz3DON_PYw-1; Sat, 19 Mar 2022 12:52:08 -0400
X-MC-Unique: NxKe_C5BMxqSBz3DON_PYw-1
Received: by mail-qv1-f72.google.com with SMTP id x16-20020a0ce250000000b00432ec6eaf85so8374401qvl.15
        for <live-patching@vger.kernel.org>; Sat, 19 Mar 2022 09:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=saWneBVb3Kut4BG7sQxMXnQsPh0IPbc8oGB5dOPI5bM=;
        b=v/OMUaaGJQRIMqdvWX9JeIurJ1S4DTe1XMz/N6hLb3xTHa6CbnRnwu9AGrImR+Pfof
         Kf2ZCqEcUGx3toFTBH5WG/4sxp5cA8yWSCCrKKwjl6GpnF3yxV4qG5+hGZGwAD07qKFd
         +OCTauNxS1UoZndMjx6Txqam+FEepE7JgftZSlvIK25uesm2Sp40uXehNvBSGLi+ZVh9
         5GaYCvZcj+l73fWZIQSWqGWKui/xurtAoD7wDoOr/8cl4HJOL6StFCDa4l5ZBXpEgoOK
         AXlIo8PaPK6/hbAFtCfmP9DSCY2m1Kv3vUOvVrYqtEYoVqLtbQF4TByViHmn5Xq777xK
         +FSA==
X-Gm-Message-State: AOAM530zQHwBDpNmcEfmM4j9z49pYxxXSVAkif43wcjOaCG+bm/WKM1t
        a+lhuVt169WN1k6LlwIULarOJOPOfLK8IcHTLflk2dHshb9NNXxIOicNOAFR2r8Gx9IHHOjmm9o
        KubwXBmYlETUOEqeoCCpjGC4N+Q==
X-Received: by 2002:a05:6214:4103:b0:440:e4d1:a2a0 with SMTP id kc3-20020a056214410300b00440e4d1a2a0mr9740315qvb.42.1647708727836;
        Sat, 19 Mar 2022 09:52:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6jHqOfsabhjqcfSHg8Xl46akmD6Zgg5f+CqiERLbL97pJUpKF0JjaYcTkKZUJbiUaFmv2Ow==
X-Received: by 2002:a05:6214:4103:b0:440:e4d1:a2a0 with SMTP id kc3-20020a056214410300b00440e4d1a2a0mr9740296qvb.42.1647708727655;
        Sat, 19 Mar 2022 09:52:07 -0700 (PDT)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id t66-20020ae9df45000000b0064915aff85fsm5399938qkf.45.2022.03.19.09.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 09:52:07 -0700 (PDT)
From:   trix@redhat.com
To:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] livepatch: Reorder to use before freeing a pointer
Date:   Sat, 19 Mar 2022 09:51:59 -0700
Message-Id: <20220319165159.2170650-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this issue
livepatch-shadow-fix1.c:113:2: warning: Use of
  memory after it is freed
  pr_info("%s: dummy @ %p, prevented leak @ %p\n",
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The pointer is freed in the previous statement.
Reorder the pr_info to report before the free.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 samples/livepatch/livepatch-shadow-fix1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index 918ce17b43fda..6701641bf12d4 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -109,9 +109,9 @@ static void livepatch_fix1_dummy_leak_dtor(void *obj, void *shadow_data)
 	void *d = obj;
 	int **shadow_leak = shadow_data;
 
-	kfree(*shadow_leak);
 	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
 			 __func__, d, *shadow_leak);
+	kfree(*shadow_leak);
 }
 
 static void livepatch_fix1_dummy_free(struct dummy *d)
-- 
2.26.3

