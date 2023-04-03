Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B04B6D54B8
	for <lists+live-patching@lfdr.de>; Tue,  4 Apr 2023 00:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjDCW0y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Apr 2023 18:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjDCW0y (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Apr 2023 18:26:54 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEBC1731
        for <live-patching@vger.kernel.org>; Mon,  3 Apr 2023 15:26:53 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id bm2so22964862oib.4
        for <live-patching@vger.kernel.org>; Mon, 03 Apr 2023 15:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680560812;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0H2b5vX2W/ngAUblsPfiPWQyDis8PRiu2qy0w7GKjAo=;
        b=B1g/0uQTCTqs9ZraWmAEMrJHp/JAt/OZ3+aLfmFSWMo3K/0HUXX2W+ia8WLDF6BVtx
         tRK2RiBgMcVwf1ZrEAF5vv2ta+Rrvc1V7qhdxvogZbcggAXOYq5Hmcj4hyjQSK1c+AEO
         rnD4v14CjHKJIE842B7Lbs3gIHvrQrO32RhfhrG8B5kTiwUWgENtUj00B889IjyxCusY
         tsyhaqNA/iUqdVwahS1LHc3qbQoVDHxQYBB7w3B3ycLPaazQ8grgNwXExycT9werv0yH
         bjKD0qM3r3w0pUZhYZzWgzx9oS2oMFzPyQG0F7oh709ktOvC/+TpPkhPDt57r66top/K
         0ZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680560812;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0H2b5vX2W/ngAUblsPfiPWQyDis8PRiu2qy0w7GKjAo=;
        b=KvVWMAr9vO72TBbtlE81yK4qSq+NEt3uhNUJ6gkCIr15CovxvwdTrgDNCIZJ+XO0NY
         jpboQN62BtogM/J+g5RJ80frx+A95yC/syPMtPOlsJTy7Xshi6XYcPioeZo8L+hIw3Yb
         XE/UbtIeM1wFZsApmnk1VgWP0BNRyJbd0vMHZWiTKzKE6cdToF7mDuXPuz3seWWMrzOc
         WGROom9EQ2RmVgpU6tuY1PKqWkXlXNhWIryNuMx7+s5KH3w6tC9TRMSnbvQz6rhtze8C
         ++WGDLX3JiHh/nzdMzzbCTA0dQX0KCWGgUTc/zTXhcmLgiuWoFnqZsylKZl5RSh0aUlt
         Hr/Q==
X-Gm-Message-State: AAQBX9c8Z/BNkNeWefK5fMdDqrej8woqm3itmMoG1dw5FJu4aYmvCGpB
        0fNxGC55k3mMwGX9dFZwaAxtIQ3ulAAt3LxYkcBxUQ==
X-Google-Smtp-Source: AKy350bYaoGraa1SOq4wyQyvp1GFGKkEVbd8IIKT2vXjlfeg7SEc1yWs1UYnVB4yQi2id6pdz4bDYPu+ce5hzCAbMZ0=
X-Received: by 2002:aca:f14:0:b0:38b:40bf:4a12 with SMTP id
 20-20020aca0f14000000b0038b40bf4a12mr257327oip.1.1680560812137; Mon, 03 Apr
 2023 15:26:52 -0700 (PDT)
MIME-Version: 1.0
From:   Dylan Hatch <dylanbhatch@google.com>
Date:   Mon, 3 Apr 2023 15:26:41 -0700
Message-ID: <CADBMgpxQ+oM_TrtKRiREcZoZSk=AfenV_bqOk_Vt-Ov5FPHMvw@mail.gmail.com>
Subject: RE: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
To:     misono.tomohiro@fujitsu.com
Cc:     broonie@kernel.org, catalin.marinas@arm.com,
        chenzhongjin@huawei.com, jamorris@linux.microsoft.com,
        jpoimboe@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        madvenka@linux.microsoft.com, mark.rutland@arm.com,
        nobuta.keiya@fujitsu.com, peterz@infradead.org, pmladek@suse.com,
        sjitindarsingh@gmail.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> Then, I noticed that invoke_syscall generates instructions to add random offset
> in sp when RANDOMIZE_KSTACK_OFFSET=y, which is true in the above case.

I'm also seeing this behavior when compiling with
RANDOMIZE_KSTACK_OFFSET=y. I wonder if a special hint type
could/should be added to allow for skipping the reliability check for
stack frames with this randomized offset? Forgive me if this is a
naive suggestion.

Thanks,
Dylan
