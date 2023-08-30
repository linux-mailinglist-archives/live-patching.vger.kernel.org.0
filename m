Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9D078D123
	for <lists+live-patching@lfdr.de>; Wed, 30 Aug 2023 02:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241433AbjH3Act (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 29 Aug 2023 20:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241073AbjH3Acc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 29 Aug 2023 20:32:32 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C728D107
        for <live-patching@vger.kernel.org>; Tue, 29 Aug 2023 17:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1693355539;
        bh=rtqXqefWaBdTc7Vn+73gF/lqYmAcwv/JWQvT26wbRSU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Dw+eJVuSXBbZmTNgDCl9I9pzEsIFC4a0h4ZYqDY5K0Fs2xZja4AOo5QTJg+6auudC
         JhgQ4R+fZoowT3VPKIAXTJqagwnq2h7AB8MoGA1CSRZ7Lc8zGsiVyND2jwzDFVS/uM
         04n/Azom2vQmSJuOE/oGtJRYAVkYK+Y4zu9Bm1xHEeMJWzmlRbmr5kgJ1ZFhZ3zKBd
         OPr76+tCyHGusUkwvOZHXrWm+tSpdkgYUzNZc9qSN7F/wwp4pvjEbCE4leu6xsf+sN
         9oo1OeMqU+hqH4SOYkKD/jy7XLFXNp300yQ+Y4pAHQ8o0DKMyoN+BNTlpzz0Vl/7UG
         KEs+oveCmJBKA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Rb4xb2X0Dz4wd0;
        Wed, 30 Aug 2023 10:32:19 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Joe Lawrence <joe.lawrence@redhat.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     live-patching@vger.kernel.org,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ryan Sullivan <rysulliv@redhat.com>
Subject: Re: Recent Power changes and stack_trace_save_tsk_reliable?
In-Reply-To: <ZO4K6hflM/arMjse@redhat.com>
References: <ZO4K6hflM/arMjse@redhat.com>
Date:   Wed, 30 Aug 2023 10:32:15 +1000
Message-ID: <87o7ipxtdc.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Joe Lawrence <joe.lawrence@redhat.com> writes:
> Hi ppc-dev list,
>
> We noticed that our kpatch integration tests started failing on ppc64le
> when targeting the upstream v6.4 kernel, and then confirmed that the
> in-tree livepatching kselftests similarly fail, too.  From the kselftest
> results, it appears that livepatch transitions are no longer completing.

Hi Joe,

Thanks for the report.

I thought I was running the livepatch tests, but looks like somewhere
along the line my kernel .config lost CONFIG_TEST_LIVEPATCH=m, so I have
been running the test but it just skips. :/

I can reproduce the failure, and will see if I can bisect it more
successfully.

cheers
