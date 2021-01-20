Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98582FD62A
	for <lists+live-patching@lfdr.de>; Wed, 20 Jan 2021 17:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbhATQxx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Jan 2021 11:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391216AbhATQxN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Jan 2021 11:53:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE29233E2;
        Wed, 20 Jan 2021 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611161553;
        bh=xsI05bmwLj1zRx+KmWWXCXJkzOXhzGREQVg7HnKAUIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZ9WMx7zPratLelEOvpA5VtXVZMea3poexeSiovBl9MP4dOVrUj0Dnas9RR0G4G4r
         YNh1o4hUpPG8zcBriyE6X5xyJObF4c4XxD6d1k3yW5MXiCtUT2NzTZ7HrO2oHuAUGM
         Ud6btBokuIWXCDyaWD3NydAk14JqM211TiGsDSf4Lm8/vvDt7IpzN6eTNrNFdQO+gt
         vqTprNRnIe3f9cJaEMj+GmoHGQiwQHzA8enEkfQwZVE7IyGqnh/F5WA7ImT8rr5nsq
         lj6Ssk8xa19+Afp479BpLN3rlkqh7L5PzsWc1VadTu2XeElGZVRAQLPEEj1jCiVVNg
         mNWCAtVgWYIGQ==
From:   Mark Brown <broonie@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-doc@vger.kernel.org, live-patching@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH v6 1/2] Documentation: livepatch: Convert to automatically generated contents
Date:   Wed, 20 Jan 2021 16:47:13 +0000
Message-Id: <20210120164714.16581-2-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210120164714.16581-1-broonie@kernel.org>
References: <20210120164714.16581-1-broonie@kernel.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; i=B41P/NyBiZr52ZgLMD1EC67DEBuJtlCAf6fQniGZ1yU=; m=tK1rm+RY1gwZaaFyY+5e8pGndilbjqiFIBPrtci03jo=; p=2MUKXici6S/sAj84vYSavNtcg2sj4YeMK0QGWULmAu0=; g=119515872595811257e582bba7d8323e2f1210c3
X-Patch-Sig: m=pgp; i=broonie@kernel.org; s=0xC3F436CA30F5D8EB; b=iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmAIXpAACgkQJNaLcl1Uh9CKEwf+KAC 3/JP6ZAl7PX1lqbxnrs4bqsw4KCUj2su9lDlC/RmzMjaw5XRkp9WLvPXxTTIhOAF14GJ95yRuoBIu 9eQfJcCyuzcFCIjSYvoni8tEbpk/Zvcl7WQDMTuaaf3jnhR2cLkwOhJJEJtzhnvkNcyO6Zt9dcS1u +/tjj+VakJxtfhS/KaaH3RDoBJ4VPj4vxfomzQM7tKVkYi9tVFDZ/lwsje+FqMhbAfeTkJoXnlPds ZTA9AJy8+GLn9YlXaJTc7gOdF7G5EgplITgvy6GJvacs0heFkhyF54A5z1vp62I14nnDkPeTtnhL0 wmxgkUpjVdw38mYmqbj8RFeSTLV68Ag==
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Automatically generate the tables of contents for livepatch documentation
files that have tables of contents rather than open coding them so things
are a little easier to maintain.

Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 Documentation/livepatch/livepatch.rst         | 15 +--------------
 Documentation/livepatch/module-elf-format.rst | 10 ++--------
 2 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
index c2c598c4ead8..68e3651e8af9 100644
--- a/Documentation/livepatch/livepatch.rst
+++ b/Documentation/livepatch/livepatch.rst
@@ -6,20 +6,7 @@ This document outlines basic information about kernel livepatching.
 
 .. Table of Contents:
 
-    1. Motivation
-    2. Kprobes, Ftrace, Livepatching
-    3. Consistency model
-    4. Livepatch module
-       4.1. New functions
-       4.2. Metadata
-    5. Livepatch life-cycle
-       5.1. Loading
-       5.2. Enabling
-       5.3. Replacing
-       5.4. Disabling
-       5.5. Removing
-    6. Sysfs
-    7. Limitations
+.. contents:: :local:
 
 
 1. Motivation
diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
index 8c6b894c4661..dbe9b400e39f 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -7,14 +7,8 @@ This document outlines the Elf format requirements that livepatch modules must f
 
 .. Table of Contents
 
-   1. Background and motivation
-   2. Livepatch modinfo field
-   3. Livepatch relocation sections
-      3.1 Livepatch relocation section format
-   4. Livepatch symbols
-      4.1 A livepatch module's symbol table
-      4.2 Livepatch symbol format
-   5. Symbol table and Elf section access
+.. contents:: :local:
+
 
 1. Background and motivation
 ============================
-- 
2.20.1

