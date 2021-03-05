Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C57032DF8C
	for <lists+live-patching@lfdr.de>; Fri,  5 Mar 2021 03:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCECRi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 4 Mar 2021 21:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCECRi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 4 Mar 2021 21:17:38 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BE2C061574;
        Thu,  4 Mar 2021 18:17:37 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id g185so583227qkf.6;
        Thu, 04 Mar 2021 18:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7OfH/7aQnmQER1/Jp2nanZu8HmrIn7USSW5vpL5BRBE=;
        b=FudP2PUGinIUc6kpmSOzXYEcgqURLa3uJm5JsiGyFmmaV5I+W8hIGd+jPLykIR3GLd
         DAxPJWYaCKyDh1B0B8uNn+Dmp5AnAMZs0scyM3zJ0rFNzIifIs7H5usfso2qkX1bxHDm
         gIbKRWQCDBPMeTLJODbIytea8/8Sp5OoLM8C3yiSwPw8CyHYjH1Ad1rBkoQVHxGFmhp4
         +N26cKo1lg7hoUv9YKG5mjnnn3ZvoVMwIF6ULTKuvo8sg6R8a7OKsiSyZnTMX+ymDdmQ
         igmtG+h1C+9wE5NTsP9dKmKmiBKdMFNg8pJ9qWUCLucOMq6JI16puWTeoHQSmhBeIZbn
         j/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7OfH/7aQnmQER1/Jp2nanZu8HmrIn7USSW5vpL5BRBE=;
        b=KGBXFoTiPyh7Yq9f0H7ws573v3auh+zqaArPDL2Ny1N1p9YS0469+FFN0GnPcOV7Ll
         e/JArMxKqnoY2xlDMgTIdIPbm5skDnH6bmK3BBLUribgQrEW6JGyPcfqtAo3c3Am5t6T
         PLeY90RKTh9jZlZYynqDVmCy7ig3Oi6mJUHr4vZEd3EHWsSVAD9+J7Jws5MftdaHnCO/
         tluysOSSdFYaW7viz7FydaT7oT7JVcsCBSbQdaKzFmbw3U8KkCEc7/iUkLjY0YC0wudL
         JLizGzo1uJcELaDwCRO63Bsb+/3FQ0x52SAN3cqDSOQnhkGR3FX6KyIPRCitLSZIq2Nz
         WRXg==
X-Gm-Message-State: AOAM531bRlBbFXQXJTc7nKT7bAqGfgcU8l/L6gVeuedts/Soz3wYelX5
        iKDjAej+ZV2CrbQbQyOwBRAW95LLDvoIOe2k
X-Google-Smtp-Source: ABdhPJyfAU2sf2GWPUNtKJrfgIpvoRbEu6kWTxG2sMJ0R8UWWWhz33cBdvGRRG0//2sv48EUaZGyvA==
X-Received: by 2002:ae9:e40b:: with SMTP id q11mr7375602qkc.318.1614910656470;
        Thu, 04 Mar 2021 18:17:36 -0800 (PST)
Received: from localhost.localdomain ([156.146.54.138])
        by smtp.gmail.com with ESMTPSA id j2sm1011601qtv.43.2021.03.04.18.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 18:17:35 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] docs: livepatch: Fix a typo in the file shadow-vars.rst
Date:   Fri,  5 Mar 2021 07:47:20 +0530
Message-Id: <20210305021720.21874-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


s/ varibles/variables/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Documentation/livepatch/shadow-vars.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/livepatch/shadow-vars.rst b/Documentation/livepatch/shadow-vars.rst
index c05715aeafa4..8464866d18ba 100644
--- a/Documentation/livepatch/shadow-vars.rst
+++ b/Documentation/livepatch/shadow-vars.rst
@@ -165,7 +165,7 @@ In-flight parent objects

 Sometimes it may not be convenient or possible to allocate shadow
 variables alongside their parent objects.  Or a livepatch fix may
-require shadow varibles to only a subset of parent object instances.  In
+require shadow variables to only a subset of parent object instances.  In
 these cases, the klp_shadow_get_or_alloc() call can be used to attach
 shadow variables to parents already in-flight.

--
2.30.1

