Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D73832E5CB
	for <lists+live-patching@lfdr.de>; Fri,  5 Mar 2021 11:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhCEKKZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Mar 2021 05:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbhCEKKL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Mar 2021 05:10:11 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99ECC061574;
        Fri,  5 Mar 2021 02:10:10 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id t4so1427864qkp.1;
        Fri, 05 Mar 2021 02:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g649SWY5Pg9iweh3f261DGBlQ2YmVzNL6uLU/MjqmfE=;
        b=EMbRLNAUW6LOBSy+mzI2wPZy6hjsPxEbyJ93p/GGgK9CQRdSOg5EAqNzM8FrPytIBB
         /62Mmz6P0Gdl6WDygDTCb/OlbtelYgsd9SSU7eynFP0abWYQWu2al7J2yeH2LtwJShRU
         bxM+WXFjRVbnan+3e1y1OxxiyhjnII0UJxdb0tSFiL4wjA+BnZcJkMCx/b3EZEnv3NHT
         OlHHItU1cUj13Ei4A19d3lKn28UcrUniHzN0my0jPiBRivrckjkliyavnywS1urctqoB
         4msaLEgfEU0IRasQi//T5i4JrLf/OW8AyjXQTpzPEh2sKYobkI1N3P0AczPM0sV16T0r
         Mz1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g649SWY5Pg9iweh3f261DGBlQ2YmVzNL6uLU/MjqmfE=;
        b=U3eLZwko27brrHgsT1k9/P2cU+qiTwBOJzNr8PTUJKVs1xccoCeTg8w5stSXDPvhm1
         zdCgPztYcpLDjH9d2cpPvgjJdC+QVfXslHS7EoPaIhklA6QChSWWtzz2uW8cwRqkNx2K
         m+FemRsRflYCLHIkOp5ipqFJdXuumws4w+rbs5jlefyzu2jnQL+/wg/nAeu4B3f7vetF
         Nbor6Zspn4R9Hami0AnypdBsovozq/8svl7DW7yf433GcmAqhj5+fazi+CGsGbcISwSe
         mNU4ZqNty78Pfwnb57vflBEjkPXaYMOSfnZXbvRGxX/MZdySDWuhjUl+rz+iaJPpKb/l
         4Y9Q==
X-Gm-Message-State: AOAM530vZMtWbk1+ZD13YSYblN/VSYTzVacjsTBC6iWxENBAYMY+/3g8
        tu1ENbtnGIvAW3psAjppxLk=
X-Google-Smtp-Source: ABdhPJySSLSA3e5v4sHWMXUdW68rSD3rQk4qdlvmCUhdA4OJxDiR3IWlaOWKjTGDubuaFBTh60k3rg==
X-Received: by 2002:a05:620a:1593:: with SMTP id d19mr8009552qkk.83.1614939010241;
        Fri, 05 Mar 2021 02:10:10 -0800 (PST)
Received: from localhost.localdomain ([156.146.54.164])
        by smtp.gmail.com with ESMTPSA id z2sm1496968qkg.22.2021.03.05.02.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 02:10:09 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH V2] docs: livepatch: Fix a typo and remove the unnecessary gaps in a sentence
Date:   Fri,  5 Mar 2021 15:39:23 +0530
Message-Id: <20210305100923.3731-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

s/varibles/variables/

...and remove leading spaces from a sentence.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Changes from V1:
  Pter pointed out some awkward  leading space in a sentence ,fixed it.

 Documentation/livepatch/shadow-vars.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/livepatch/shadow-vars.rst b/Documentation/livepatch/shadow-vars.rst
index c05715aeafa4..2ee114a91a35 100644
--- a/Documentation/livepatch/shadow-vars.rst
+++ b/Documentation/livepatch/shadow-vars.rst
@@ -165,8 +165,8 @@ In-flight parent objects

 Sometimes it may not be convenient or possible to allocate shadow
 variables alongside their parent objects.  Or a livepatch fix may
-require shadow varibles to only a subset of parent object instances.  In
-these cases, the klp_shadow_get_or_alloc() call can be used to attach
+require shadow variables to only a subset of parent object instances.
+In these cases, the klp_shadow_get_or_alloc() call can be used to attach
 shadow variables to parents already in-flight.

 For commit 1d147bfa6429, a good spot to allocate a shadow spinlock is
--
2.20.1

