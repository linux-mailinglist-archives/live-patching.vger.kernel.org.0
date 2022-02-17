Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6B34B9AB4
	for <lists+live-patching@lfdr.de>; Thu, 17 Feb 2022 09:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbiBQINY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 17 Feb 2022 03:13:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237139AbiBQINR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 17 Feb 2022 03:13:17 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB361408F;
        Thu, 17 Feb 2022 00:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MKddAxvR3DVk8W8n64+95ExqskCi1xkJSKR1SJCsL1U=; b=MAYBG/zhPbiffNY7Ezk4TsQ8s9
        AQQDBYLz7ssEil/nEFhalLlCFlHKiwchSi/QOFznkxgD0K77IQZvSmdwutNxO/Cl/gPEVHuyrrTMC
        u/Xvj+8BcQlNIfy+feGdAd/0zWDcczi02c7WEzlGZ2jI3I1gB39l2dCBWZ/0KVgqoVB72i7CTIsa1
        CriF7E6ZbNci1cLxFo8VW+PdtHczCTIKFH9zji8wWTrxnDPvveB/MyGIS9WjhBkoG0yQQfwXPaHku
        VqW6unSccjNd/y9VDPsExKfsKT3mfGa49Mfn4yZZw3Y2SGLtLha+Y106B6McXvhElA3pM82Mid1TS
        UJ3RNDGA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKbuP-009NfT-1U; Thu, 17 Feb 2022 08:13:01 +0000
Date:   Thu, 17 Feb 2022 00:13:01 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc:     Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-modules <linux-modules@vger.kernel.org>,
        live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        Jessica Yu <jeyu@kernel.org>, osandov@fb.com,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] kmod: add patient module removal support
Message-ID: <Yg4Djc+vqRbMFRto@bombadil.infradead.org>
References: <20210810051602.3067384-1-mcgrof@kernel.org>
 <YUIwKUXc7YbVAqut@bombadil.infradead.org>
 <CAKi4VAKbN31hqfg5EHZO=T_Hdkv3uhzarFLuEZO4b5Zm+TF77Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKi4VAKbN31hqfg5EHZO=T_Hdkv3uhzarFLuEZO4b5Zm+TF77Q@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Sep 20, 2021 at 10:51:46PM -0700, Lucas De Marchi wrote:
> On Wed, Sep 15, 2021 at 10:41 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > *Friendly poke*
> 
> Sorry for the delay. Let me take a look in detail tomorrow.

*Friendly poke*

  Luis
