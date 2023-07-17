Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5382F756990
	for <lists+live-patching@lfdr.de>; Mon, 17 Jul 2023 18:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjGQQun (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jul 2023 12:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjGQQum (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jul 2023 12:50:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C15FA;
        Mon, 17 Jul 2023 09:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J0V5hV3Q+TS5tLVW5XW3ouizk5qxGr8MqtaRegwhqZc=; b=Z8mq/QYAjoh0dqYla8C9CtAFzt
        bwLmfk75nM/6hQubJHdZxiixAVS6fndkY2oLmBQ1Cs5X9uGJ7kerjsZnKlTUz4NX+exOVlRoMyYd+
        xBWNIoc7kz3cT4xZCzuFgTkYIJrXF/OFUzvXowH6x0AvoOpfr+86How26Wvqyy3T1G4Pf1lqmutXN
        7MDUEn4x0UBrExFVTTeRiDL+LAW4KF5VX5N/ydgLzPc9iiFL8uFF8QkURp99AA0veMm0OHJPTtWQd
        n2uE5mjgsxSwlQZ8uqbyKvECkdrO0YrtLazppU6eIQoJ1N3Ny9lv2crLlv9tP67fWnn4mU4tEMMVT
        zopy598Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qLRQX-004aby-0S;
        Mon, 17 Jul 2023 16:50:25 +0000
Date:   Mon, 17 Jul 2023 09:50:25 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alessandro Carminati <alessandro.carminati@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Viktor Malik <vmalik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Nick Alcock <nick.alcock@oracle.com>, eugene.loh@oracle.com,
        kris.van.hees@oracle.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
Message-ID: <ZLVxUQiC5iF+xTPQ@bombadil.infradead.org>
References: <20230714150326.1152359-1-alessandro.carminati@gmail.com>
 <20230717105240.3d986331@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717105240.3d986331@gandalf.local.home>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jul 17, 2023 at 10:52:40AM -0400, Steven Rostedt wrote:
> Honestly, I think the "_alias_<some-random-number>" is useless. It doesn't
> give you any clue to what function you are actually attaching to. 

Agreed.

> There's
> been other approaches that show module and/or file names. I know there's
> still some issues with getting those accepted, but I much rather have them
> than this!
> 
> See: https://lore.kernel.org/all/20221205163157.269335-1-nick.alcock@oracle.com/

Yes, please coordinate with Nick and review each other's work, now we
have two separate efforts with different reasons but hopefully we'll
come back with one unified solution.

Please Cc live-patching also, as they had suggested before just to
provide the file filename + line number, that'll make it even more
valuable.

  Luis
