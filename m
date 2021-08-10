Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5E53E5295
	for <lists+live-patching@lfdr.de>; Tue, 10 Aug 2021 07:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbhHJFQ2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 Aug 2021 01:16:28 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:52908 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhHJFQ1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 Aug 2021 01:16:27 -0400
Received: by mail-pj1-f41.google.com with SMTP id nt11so8237964pjb.2;
        Mon, 09 Aug 2021 22:16:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+zpOwbVou+jByg13qU0+g7J5etP/Qu5p7QOKi2Ty4XA=;
        b=laxUOlDEkOJJhs8ogySOueYxKJg9sD+f9g+cHBqW6zFqDKc0hPTX/Am2gz2YRwSgxs
         ao42THc7o+8yA5tkvjUSnJvRaES1TEAurj7VRtbMIn40bbN9a9vLkDz3C4+iEhVvULrP
         FMCzpc2440tLbMPq9TPmlLOrUjamlTgL8hp6zA73VdCOOSPshgcVYU9MO1SM4j0YTZ/u
         bCdmVL6HoMUy4QC3OpSX/qtF6K1miqLwbQGBK9wVLR7dmSI1Es1kvi/W/ifqrQhBlvKO
         xCUnyERfg/wcADWbZE6NjfaCEdASyFnivYaerGJNqDz6YIzVcpp5seIoGTAlM3jIDuEi
         y3jg==
X-Gm-Message-State: AOAM531lmNr4MQIq6MnXk6ceSaVoMBsbjAAW8Snuv1P/98sRm6nMAvXB
        cGK6BCaOoujavs+VRBo0BJM=
X-Google-Smtp-Source: ABdhPJzyR0y8ESWGngQYGnUiWJ+Fr8MT9kxQa18PzVznFkcJjdUEqna8/JSJHjUV9s7UHJXZA/WPXw==
X-Received: by 2002:a17:902:c404:b029:12c:4e68:ba6e with SMTP id k4-20020a170902c404b029012c4e68ba6emr21475883plk.39.1628572566003;
        Mon, 09 Aug 2021 22:16:06 -0700 (PDT)
Received: from localhost ([191.96.121.128])
        by smtp.gmail.com with ESMTPSA id p34sm21806624pfh.172.2021.08.09.22.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 22:16:04 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     lucas.demarchi@intel.com, linux-modules@vger.kernel.org
Cc:     live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        jeyu@kernel.org, osandov@fb.com, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 0/3] kmod: add patient module removal support
Date:   Mon,  9 Aug 2021 22:15:59 -0700
Message-Id: <20210810051602.3067384-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The kernel used to have wait support for delete_module() system call.
This was removed via commmit 3f2b9c9cdf389e ("module: remove rmmod
--wait option.") on v3.13 in favor for 10 second sleep on kmod. Lucas
later remove that sleep(10) on kmod commit 017893f244 ("rmmod: remove
--wait option") so on kmod 16.

There are races in module removal I have been chasing down and
clearly documenting them. Module removal is not crazy stuff, its
used in many test frameworks such as fstests and blktests and can
even be used to remove live patches if a distribution supports that.
If you are doing tests in a loop you can easily run into these races
as false positives in your testing results.

Contrary to the last kernel wait delete_module() effort this series
instead adds a patient module removal support into kmod and extends
modprobe and rmmod to use it.

The most important change other than the requested during patch
review this also now uses the same timeout to also re-try module
removal if it fails when patient module removal is used.

Changes on v2:

- replace looking at the refcnt with poll() as requested by Lucas.
  This uses clock_gettime(CLOCK_MONOTONIC), and systems without that
  won't get patient module removal support, we'd revert back to
  regular module removal attempt support. Since poll() in practice
  just busy loops on the refcnt sysfs file today, we guard verbose
  prints to only every 1/2 second. We can enhance poll() on the refcnt
  later, for now this busy read helps prove the issue and test for it.
- replaces the sleep(1) calls and make thie programmable timeouts as
  requested by Lucas
- extends macros to allow us to print something *more* on the library
  when something like modprobe -v is used.
- upon further testing and investigation of the refcnt issue where
  the refcnt is 0 but the module cannot be removed [0] I've determined
  that the only reasonable thing userspace can do is to retry the
  delete_modue() call when doing a patient removal. You *might*
  be tempted to look at this and suggest a new quiesce state which
  userspace can request, however such quiesce states could actually
  prove more problemantic than resolve anything. Consider how some
  subystems may need to re-open a device only to close it when tearing
  something down. Such quiesce efforts would break those subsystems.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=214015

Luis Chamberlain (3):
  libkmod: add a library notice log level print
  libkmod/libkmod-module: add refcnt fd helper
  libkmod-module: add support for a patient module removal option

 libkmod/docs/libkmod-sections.txt  |   4 +
 libkmod/libkmod-internal.h         |   2 +
 libkmod/libkmod-module.c           | 365 ++++++++++++++++++++++++++++-
 libkmod/libkmod.c                  |  71 ++++++
 libkmod/libkmod.h                  |   7 +
 libkmod/libkmod.sym                |   4 +
 libkmod/python/kmod/_libkmod_h.pxd |   3 +
 libkmod/python/kmod/module.pyx     |   4 +
 man/modprobe.xml                   |  59 +++++
 man/rmmod.xml                      |  60 +++++
 tools/modprobe.c                   |  21 +-
 tools/remove.c                     |  12 +-
 tools/rmmod.c                      |  27 ++-
 13 files changed, 610 insertions(+), 29 deletions(-)

-- 
2.30.2

