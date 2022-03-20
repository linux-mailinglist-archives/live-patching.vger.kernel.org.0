Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77C24E1960
	for <lists+live-patching@lfdr.de>; Sun, 20 Mar 2022 02:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbiCTBxQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 19 Mar 2022 21:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbiCTBxP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 19 Mar 2022 21:53:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 376C217AD85
        for <live-patching@vger.kernel.org>; Sat, 19 Mar 2022 18:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647741112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7+g4lBbR9wGQEz+SJAnS0Y/H4dktfXz+TnU3wixu7kw=;
        b=OoeMdSkCHi6Btzs9ZtpOChmd9QfHGbY09CFFS/LTfBefzUtMbfiBk70V/Nrwu/HXz28ivz
        Ifbk+DhAyjFxuwxD63n1ndibLk3egYuf/3cUK02s7MCKpGHinhDuNXXera20KSHKKQ/1+B
        ztQ4twjotS82iCxJy4jHDyDkhAwp6Aw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-0JPamq1EMZ-UiM9w8JoNWA-1; Sat, 19 Mar 2022 21:51:50 -0400
X-MC-Unique: 0JPamq1EMZ-UiM9w8JoNWA-1
Received: by mail-qk1-f197.google.com with SMTP id bj2-20020a05620a190200b005084968bb24so7685717qkb.23
        for <live-patching@vger.kernel.org>; Sat, 19 Mar 2022 18:51:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7+g4lBbR9wGQEz+SJAnS0Y/H4dktfXz+TnU3wixu7kw=;
        b=qS9j4cnVwwNB3VCy3VX9U7PfL0vosew3sjnMYVM4tuQZJ32DccIG24xINgzveVNooe
         f41d9p2lHQ3R1Ui86vnhwwQE284uxh/8id7jqwAbXSIN9ea4efxl+1R3s1Owz/WUBbM8
         KzNlbAk1jcAtLPj8WU+KaJWKpcNFbu1mEf1u2qv2M1VEdO2Y1w6uct6Uay9fObuW4RpY
         jvcEJm2xQRgMiUM2E2rL5YUVawTAwL8yfCY2KcOsBakTjp6d7NU6NCUiP2+MGrTZDKeY
         TH4d0iWQjIcn8g1ViIR8NpR80+qRj26xfmupwnB1Gm5Kuacublo8+kfPZnx3OH2M8T1Z
         Mrjw==
X-Gm-Message-State: AOAM531b208z9F+FerZEhg5L9AZT/QpIV9YgI1U/3p5IDgtHG4obIWoi
        1CzC4ojbf5yAB5wSSZBwGzcqgOkgQZQCQcmETd8iuaYmbJLz+S3h1j2N/c1LQmrO7ARfmRlMF4+
        mxHE8CIEIXcUX8pzh5o69nRpVMg==
X-Received: by 2002:a05:620a:c55:b0:67e:125b:38ea with SMTP id u21-20020a05620a0c5500b0067e125b38eamr9466518qki.396.1647741110113;
        Sat, 19 Mar 2022 18:51:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPyxoS2+EPm6TLHGvV+PXYG2sNsQSCkRQCFPHHcE/rizQ+uCKCH6QvrePSyI3ldbboUgS8bQ==
X-Received: by 2002:a05:620a:c55:b0:67e:125b:38ea with SMTP id u21-20020a05620a0c5500b0067e125b38eamr9466513qki.396.1647741109877;
        Sat, 19 Mar 2022 18:51:49 -0700 (PDT)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id z15-20020a05622a060f00b002e2070bf899sm3079882qta.90.2022.03.19.18.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 18:51:49 -0700 (PDT)
From:   trix@redhat.com
To:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] livepatch: Reorder to use before freeing a pointer
Date:   Sat, 19 Mar 2022 18:51:43 -0700
Message-Id: <20220320015143.2208591-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Similar issue in livepatch-shadow-fix2.c

Signed-off-by: Tom Rix <trix@redhat.com>
---
v2: Fix similar issue in livepatch-shadow-fix2.c

 samples/livepatch/livepatch-shadow-fix1.c | 2 +-
 samples/livepatch/livepatch-shadow-fix2.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
diff --git a/samples/livepatch/livepatch-shadow-fix2.c b/samples/livepatch/livepatch-shadow-fix2.c
index 29fe5cd420472..361046a4f10cf 100644
--- a/samples/livepatch/livepatch-shadow-fix2.c
+++ b/samples/livepatch/livepatch-shadow-fix2.c
@@ -61,9 +61,9 @@ static void livepatch_fix2_dummy_leak_dtor(void *obj, void *shadow_data)
 	void *d = obj;
 	int **shadow_leak = shadow_data;
 
-	kfree(*shadow_leak);
 	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
 			 __func__, d, *shadow_leak);
+	kfree(*shadow_leak);
 }
 
 static void livepatch_fix2_dummy_free(struct dummy *d)
-- 
2.26.3

