Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A503F90C4
	for <lists+live-patching@lfdr.de>; Fri, 27 Aug 2021 01:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhHZWfW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Aug 2021 18:35:22 -0400
Received: from mail-yb1-f173.google.com ([209.85.219.173]:36851 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbhHZWfW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Aug 2021 18:35:22 -0400
Received: by mail-yb1-f173.google.com with SMTP id f15so8878145ybg.3
        for <live-patching@vger.kernel.org>; Thu, 26 Aug 2021 15:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=X/STzz3xbXrNWtIX6dH3xgqdevdigA3hDWCRpqHOAxc=;
        b=mtzOg9A1SXSb/8lNeplWcQPQsJehmCJsPGp92SPoFrVj7QzyGvc9S/+jqh8ECCOuqW
         yWmLX961kiwj8wAamtAFlX7HuYgraqdIAajIhvIQrogsM0XY+jMObH/Ayww5/XRTJlEz
         TPVfu3H9fjuBMVqruLLjbe5i5ozTjmhBpKYwmVoLNazHTE3u/BZBT+sZYFQmpzZwSu9Z
         tzJxbMwFY+pnUNucO8RmM3sbplk7gCCOe4kfl5KzUxqo7izb46kpMSWNoCCCx2dgTGyQ
         Y2/5JKrApDpPrb/iWoY6QkFbQWuG9SXzcccNkdcAoiwd5ivVxicODbgotl8dZC3IFmDZ
         6EgA==
X-Gm-Message-State: AOAM530swVpvqi4OJN8SEMtjBjDg+ExKrZ+Ne8iXHk1o8XXHZ6EIKioX
        UP8auASixOAfm9AK2ga48rvnuzQmsoYI+48SWrjuE0Hj+Qg=
X-Google-Smtp-Source: ABdhPJzSudQWUnA367Hvs5oSVHSU+mozx0we2Ietm7jpfsz7ySaOpbhrIvJABtYRdmVJ/TUI+dVpMmUXdBh3M4CSIFs=
X-Received: by 2002:a25:1244:: with SMTP id 65mr1413110ybs.46.1630017273945;
 Thu, 26 Aug 2021 15:34:33 -0700 (PDT)
MIME-Version: 1.0
From:   Peter Swain <swine@pobox.com>
Date:   Thu, 26 Aug 2021 15:34:23 -0700
Message-ID: <CABFpvm2o+d0e-dfmCx7H6=8i3QQS_xyGFt4i3zn8G=Myr_miag@mail.gmail.com>
Subject: announcing LLpatch: arch-independent live-patch creation
To:     live-patching@vger.kernel.org, madvenka@linux.microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

We have a new userspace live-patch creation tool, LLpatch, paralleling
kpatch-build, but without requiring its arch-specific code for ELF
analysis and manipulation.

We considered extending kpatch-build to a new target architecture
(arm64), cluttering its code with details of another architecture’s
quirky instruction sequences & relocation modes, and suspected there
might be a better way.


The LLVM suite already knows these details, and offers llvm-diff, for
comparing generated code at the LLVM-IR (internal representation)
level, which has access to much more of the code’s _intent_ than
kpatch’s create-diff-object is able to infer from ELF-level
differences.


Building on this, LLpatch adds namespace analysis, further
dead/duplicate code elimination, and creation of patch modules
compatible with kernel’s livepatch API.

Arm64 is supported - testing against a livepatch-capable v5.12 arm64
kernel, using the preliminary reliable-stacktrace work from
madvenka@linux.microsoft.com, LLpatch modules for x86 and arm64 behave
identically to the x86 kpatch-build modules, without requiring any
additional arch-specific code.

On x86, where both tools are available, LLpatch produces smaller patch
modules than kpatch, and already correctly handles most of the kpatch
test cases, without any arch-specific code. This suggests it can work
with any clang-supported kernel architecture.


Work is ongoing, collaboration is welcome.


See https://github.com/google/LLpatch for further details on the
technology and its benefits.


Yonghyun Hwang (yonghyun@google.com freeaion@gmail.com)
Bill Wendling (morbo@google.com isanbard@gmail.com)
Pete Swain (swine@google.com swine@pobox.com)
