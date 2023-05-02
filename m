Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0E56F493A
	for <lists+live-patching@lfdr.de>; Tue,  2 May 2023 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbjEBRkp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 May 2023 13:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbjEBRko (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 May 2023 13:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB54F114
        for <live-patching@vger.kernel.org>; Tue,  2 May 2023 10:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58509621CC
        for <live-patching@vger.kernel.org>; Tue,  2 May 2023 17:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCBBC433EF
        for <live-patching@vger.kernel.org>; Tue,  2 May 2023 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683049242;
        bh=hSNlmZG34nJnElMIlu0ravnV4E2D4HAVe3MCXh8CaFY=;
        h=From:Date:Subject:To:From;
        b=EN6jL75+UCMSgGgpWZooPDzaMetBC+8ZQrUQt8wWWd762P9K0D5tFl0mKCN2b+7+C
         uT1FvCLodXYWLaDggRawW7WCzibvxKpYZqssdLty8oKYsW89e6eYrcNXaAsy6dij2O
         e4pZf24b5InlyD6Uw1tZxVa/CRKQ2NxUtcL6PFkOduyUNQ0zPYzLnVk+UK0YFAVGCS
         MVL06qB5x2uajJqF+KGtYxbLUwz3VntBZE1Bkao2WjEiTYWHK590km+/zQs3qd1vd4
         TkZGvLi/z1Ody5rfpXVbjUG+b26suz+uVMtzEHqWrRRtqb3jwHyoG7JbdM0cVVSaVd
         2Dhk6izWRgklg==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2a8dd1489b0so39680751fa.3
        for <live-patching@vger.kernel.org>; Tue, 02 May 2023 10:40:42 -0700 (PDT)
X-Gm-Message-State: AC+VfDwDHj/ab6AcGk6aCmclEINeRTZZyIf2IRz+yWd70qxpRt8OzY8o
        OhNuy3+v1CIKdVV9J6oxLagWNy+9TqO/PQPRDO4=
X-Google-Smtp-Source: ACHHUZ6YL1Is3DhVORaMM68IhPp36emUGa3h8O5RwDrGFZbjp6Yi/aWxvmM+YikY1EIdtYaDWLHrg42Z+FE5kiyTrSo=
X-Received: by 2002:a05:6512:11e2:b0:4eb:401e:1b76 with SMTP id
 p2-20020a05651211e200b004eb401e1b76mr169581lfs.52.1683049240720; Tue, 02 May
 2023 10:40:40 -0700 (PDT)
MIME-Version: 1.0
From:   Song Liu <song@kernel.org>
Date:   Tue, 2 May 2023 10:40:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW58LYU8iRCjoeChCyQ_7gqZvp6_U-fJr2Crf6gOniA51g@mail.gmail.com>
Message-ID: <CAPhsuW58LYU8iRCjoeChCyQ_7gqZvp6_U-fJr2Crf6gOniA51g@mail.gmail.com>
Subject: Question about inline, notrace, and livepatch
To:     live-patching@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

We hit the following hiccup a couple times in the past few months:

A function is marked as "inline", but the compiler decided not to inline it.
Since "inline" implies "notrace" since [1], this function doesn't have
fentry/mcount. When we built livepatch for this function, kpatch-build
failed with:

   xxx.o: function yyy has no fentry/mcount call, unable to patch

This is not a deal breaker, as we can usually modify the patch to work
around it. But I wonder whether we still need "inline" to imply "notrace".
Can we remove this to make livepatch a little easier?

Thanks,
Song

[1] 93b3cca1ccd3 ("ftrace: Make all inline tags also include notrace")
